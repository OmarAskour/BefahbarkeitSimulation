classdef datenbank
    methods(Static)
        
        function tbl = fetchData()
            global table;
            global current_id;
            table = readtable('konfigurator_data.csv','Delimiter',',');
            if (height(table) > 0)
                current_id = table{1,1};
            end
            tbl = table;
        end
        
        function range = getLangeSeiteTreppenRange(row, nicht_verzogene_stufen, L_nicht_verzogen, treppen_limit_x)
            
            x_lange_seite_aussen = [];
            
            stufen_aussen = str2num(char(row));
            
            for i = 1:length(stufen_aussen)
                x = 100;
                delta_aussen = 0
                for j = 1:i
                    val = stufen_aussen(j);
                    delta_aussen = delta_aussen + val;
                end
                x_lange_seite_aussen = [x_lange_seite_aussen; x + delta_aussen];
            end
            
            %calculate the offset for non verzogene stufen
            step_size = L_nicht_verzogen / nicht_verzogene_stufen;
            for i = 1:(nicht_verzogene_stufen - 1)
                x = (treppen_limit_x - L_nicht_verzogen);
                delta_aussen = 0
                for j = 1:i
                    delta_aussen = delta_aussen + step_size;
                end
                x_lange_seite_aussen = [x_lange_seite_aussen; x + delta_aussen];
            end
            
            lange_seite_range = [];
            
            for i = 1:length(x_lange_seite_aussen)
                min = 0; max = 0;
                if i == 1
                    min = 100;
                    max = x_lange_seite_aussen(i);
                else
                    min = x_lange_seite_aussen(i - 1);
                    max = x_lange_seite_aussen(i) 
                end
                lange_seite_range = [lange_seite_range; [min max]];
            end
            
            min = x_lange_seite_aussen(length(x_lange_seite_aussen));
            max = treppen_limit_x;
            lange_seite_range = [lange_seite_range; [min max]];
            range = lange_seite_range;
        end
        
        function range = getKurzSeiteTreppenRange(row, Lange_raduis, Lange_verzogen, lichte)
            
            y_kurze_seite_innen = []
            
            stufen_innen = str2num(char(row))
            
            for i = 1:length(stufen_innen)
                y = 100;
                delta_innen = 0
                for j = 1:i
                    delta_innen = delta_innen + stufen_innen(j);
                end
                y_kurze_seite_innen = [y_kurze_seite_innen; y + delta_innen];
            end
            
            kurze_seite_range = []
            
            for i = 1:length(y_kurze_seite_innen)
                min = 0; max = 0;
                if i == 1
                    min = 100;
                    max = y_kurze_seite_innen(i);
                else
                    min = y_kurze_seite_innen(i - 1);
                    max = y_kurze_seite_innen(i) 
                end
                kurze_seite_range = [kurze_seite_range; [min max]];
            end
            
            min = y_kurze_seite_innen(length(y_kurze_seite_innen));
            max = Lange_verzogen + Lange_raduis + lichte;
            kurze_seite_range = [kurze_seite_range; [min max]];
            range = kurze_seite_range;
        end
        
        function z = calculateZ(steigungshoehe, x, y, x_kurze_seite_min, x_kurze_seite_max, kurze_seite_range, y_kurze_seite_min, y_kurze_seite_max, lange_seite_range)
            %calculate the value of z for a lauflinie point (x,y)
            stufen_nr = 0;
            
            %if this condition is true, then the point is in kurze seite
            if x <= x_kurze_seite_max && x >= x_kurze_seite_min
                for i = 1:length(kurze_seite_range)
                    stufen_nr = stufen_nr + 1;
                    min = kurze_seite_range(i,1);
                    max = kurze_seite_range(i,2);
                    if y >= min && y < max
                        break;
                    end 
                end
                disp(strcat("(", num2str(x), ",", num2str(y), ") found in kurzeseite"));
            else
                %the point is in the lange seite
                stufen_nr = length(kurze_seite_range);
                 for i = 1:length(lange_seite_range)
                    stufen_nr = stufen_nr + 1;
                    min = lange_seite_range(i,1);
                    max = lange_seite_range(i,2);
                    if x >= min && x < max
                        break;
                    end 
                end
                disp(strcat("(", num2str(x), ",", num2str(y), ") found in langeseite"));
            end
            disp(strcat("Calculated z: ", num2str(stufen_nr * steigungshoehe)));
            z = stufen_nr * steigungshoehe; 
        end
        
        function addData(new_row, model_id)
            global table;
            if isempty(table)
                table = cell2table(new_row)
            else
                table = [table; new_row];
            end

            conn = sqlite('simulator_datenbank.sqlite', 'connect');
           
            %Store data in Konfigurator
            model_image = new_row{4};  
            colnames = {'model_id', 'model_image'};
            %column names of the database table. To check them use .schema tablename
            data = {model_id, model_image};
            data_table=cell2table(data, 'VariableNames', colnames);
            insert(conn, 'Konfigurator', colnames, data_table);
            
            %Store data in Stufen_Kurzeseite
            stufen_nr = str2num(char(new_row{5}))
            stufen_innen = str2num(char(new_row{6}))
            stufen_aussen = str2num(char(new_row{7}))
            verzogene = length(stufen_nr);
            colnames = {'stufen_nr', 'innenabstand', 'aussenabstand' , 'model_id'};
            for i = 1:length(stufen_nr)
                data = {stufen_nr(i), stufen_innen(i), stufen_aussen(i), model_id};
                data_table=cell2table(data, 'VariableNames', colnames);
                insert(conn, 'Stufen_Kurzeseite', colnames, data_table);
            end
            
            %Store data in Stufen_Langeseite
            stufen_nr = str2num(char(new_row{8}))
            stufen_innen = str2num(char(new_row{9}))
            stufen_aussen = str2num(char(new_row{10}))
            verzogene = verzogene + length(stufen_nr);
            colnames = {'stufen_nr', 'innenabstand', 'aussenabstand' , 'model_id'};
            for i = 1:length(stufen_nr)
                data = {stufen_nr(i), stufen_innen(i), stufen_aussen(i), model_id};
                data_table=cell2table(data, 'VariableNames', colnames);
                insert(conn, 'Stufen_Langeseite', colnames, data_table);
            end
            
            %Store data in Lauflinie
            steigungshoehe = getappdata(0, 'steigungshohe');
            treppenbreite = getappdata(0, 'treppenbreite');
            Gesamt_ver_Stufen = getappdata(0, 'Gesamt_ver_Stufen'); %n-verz
            Stufen_laufradius = getappdata(0, 'Stufen_laufradius'); %n-rad
            stufen_anzahl = getappdata(0, 'stufen_anzahl');
            auftrittsbreite = getappdata(0, 'auftrittsbreite');
            
            L_nicht_verzogen = (stufen_anzahl - Gesamt_ver_Stufen) * auftrittsbreite;
            Lange_raduis = auftrittsbreite * 0.5 / sin(deg2rad(45/Stufen_laufradius));
            Lange_verzogen = (Gesamt_ver_Stufen - Stufen_laufradius) / 2 * auftrittsbreite;
            lichte = treppenbreite / 2;
            
            x_kurze_seite_min = 100; x_kurze_seite_max = 100 + treppenbreite;
            kurze_seite_range = datenbank.getKurzSeiteTreppenRange(new_row{6}, Lange_raduis, Lange_verzogen, lichte)

            y_kurze_seite_min = Lange_raduis + Lange_verzogen + lichte - treppenbreite;
            y_kurze_seite_max = Lange_raduis + Lange_verzogen + lichte;
            lange_seite_range = datenbank.getLangeSeiteTreppenRange(new_row{10}, stufen_anzahl - verzogene, L_nicht_verzogen, 100 + Lange_raduis + Lange_verzogen + lichte + L_nicht_verzogen);
            
            colnames = {'x', 'y', 'z' ,'orientation', 'model_id'};
            x = str2num(char(new_row{2}));
            y = str2num(char(new_row{3}));
            for i = 1:length(x)
                orientation = 0.0
                if i < length(x)
                    orientation = atand((y(i) - y(i+1)) / (x(i) - x(i+1)));
                end
                z = datenbank.calculateZ(steigungshoehe, x(i), y(i), x_kurze_seite_min, x_kurze_seite_max, kurze_seite_range, y_kurze_seite_min, y_kurze_seite_max, lange_seite_range);
                data = {x(i), y(i), z, orientation, model_id};
                data_table=cell2table(data, 'VariableNames', colnames);
                insert(conn, 'Lauflinie', colnames, data_table);
            end
            
            %Store data in Treppendaten
            geschosshoehe = getappdata(0, 'geschosshoehe');
            colnames = {'geshcosshoehe', 'treppenbreite', 'anzahl_zu_verziehender_stufen', 'anzahl_stufen_im_laufradius', 'steigungshoehe', 'auftrittsbreite', 'gesamtstufenanzahl', 'model_id'};
            %column names of the database table. To check them use .schema tablename
            data = {geschosshoehe, treppenbreite, Gesamt_ver_Stufen, Stufen_laufradius, steigungshoehe, auftrittsbreite, stufen_anzahl, model_id};
            data_table=cell2table(data, 'VariableNames', colnames);
            insert(conn, 'Treppendaten', colnames, data_table);
            
            close(conn);
           
            writetable(table, "konfigurator_data.csv");
        end
        
        function id = getLastSavedId()
            global table;
            if isempty(table)
                id = 0;
            else
                id = height(table);
            end
        end
        
        function data = getCurrentRow()
            global table;
            global current_id;
            data = table(current_id,:);
        end
        
        function data = getNextRow()
            global table;
            global current_id;
            
            if current_id < height(table)
                current_id = current_id + 1;
            end
            data = table(current_id,:);
        end
        
        function data = getPrevRow()
            global table;
            global current_id;
            
            if current_id > 1
                current_id = current_id - 1
            end
            data = table(current_id,:);
        end
        
        function deleteCurrentModel()
            global table;
            global current_id;
            new_id = -1;
            if current_id == 1 && height(table) ~= 1
                new_id = current_id + 1
            elseif current_id == height(table) && height(table) ~= 1
                new_id = current_id - 1
            elseif height(table) == 1
                new_id = 0
            elseif current_id == height(table) - 1
                new_id = current_id 
            else
                new_id = current_id + 1
            end
            table(current_id, :) = [];
            writetable(table, "konfigurator_data.csv");
            current_id = new_id
        end
    end
end
