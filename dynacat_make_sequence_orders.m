
% CODE TO GENERATE SEQUENCE ORDERS AND EXPORT TO CSVs
% updated 18 Sept 2023 for new dynacat ordering with no scrambled motion 

participant_code = 'P07';

seq.num_conds = 9;
seq.num_runs = 10;

seq.stim_category_conditions = {'faces' 'hands' 'bodies' 'animals' 'objects1' 'objects2' 'scenes1' 'scenes2' 'baseline'};
seq.stim_dynamic_conditions = {'normal' 'linear' 'still' 'baseline'};
seq.conditions = {'baseline' 'task_repeat' 'faces-normal' 'faces-linear' 'faces-still' 'hands-normal' 'hands-linear' 'hands-still' 'bodies-normal' 'bodies-linear' 'bodies-still' 'animals-normal' 'animals-linear' 'animals-still' 'objects1-normal' 'objects1-linear' 'objects1-still' 'objects2-normal' 'objects2-linear' 'objects2-still' 'scenes1-normal' 'scenes1-linear' 'scenes1-still' 'scenes2-normal' 'scenes2-linear' 'scenes2-still'};
seq.background = 'controlled_backgrounds';
seq.stim_per_category = 8; % 8 (8 for each category, 2 per dynamic condition)
seq.stim_duration = 4;

seq.exp_dir = '/Users/beth/Desktop/DynaCat/dynacat_stimuli';
baseline_dir = '/Users/beth/Desktop/DynaCat/dynacat_stimuli/controlled_backgrounds/baseline.mp4';

seq.stim_per_condition = 2; %add this to main sequence
seq.num_categories = 8;

%task stuff
seq.num_task_repeats = 4;
seq.max_task_repeat_distance = 10; %task repeats happen a max of 40 seconds after original stim
seq.task_repeat_stimuli = cell(seq.num_task_repeats, seq.num_runs);
seq.task_repeat_stimuli_indices = cell(seq.num_task_repeats, seq.num_runs);


%get ordered conditions
block_conds = make_orders(seq.num_conds, seq.num_conds, seq.num_runs);
block_conds = [zeros(1, seq.num_runs); block_conds; zeros(1, seq.num_runs); zeros(1, seq.num_runs)]; %added 2 extra baselines at end

%intialize arrays to save all conditions (categories * dynamic conditions) and condition names
block_conds_all = cell(length(block_conds * seq.stim_per_category), seq.num_runs); %task repeats will be added
condition_names = cell(length(block_conds * seq.stim_per_category), seq.num_runs); %no task repeats



% make array of condition numbers in balanced orders

for run_num = 1:seq.num_runs

    possible_dynamic_conds = [0; 1; 1; 2; 2; 3; 3; 0; 0];
    
    %shuffle orders per condition
    dynamic_cond_order_hands = possible_dynamic_conds(randperm(length(possible_dynamic_conds)));
    dynamic_cond_order_faces = possible_dynamic_conds(randperm(length(possible_dynamic_conds)));
    dynamic_cond_order_bodies = possible_dynamic_conds(randperm(length(possible_dynamic_conds)));
    dynamic_cond_order_animals = possible_dynamic_conds(randperm(length(possible_dynamic_conds)));
    dynamic_cond_order_objects1 = possible_dynamic_conds(randperm(length(possible_dynamic_conds)));
    dynamic_cond_order_objects2 = possible_dynamic_conds(randperm(length(possible_dynamic_conds)));
    dynamic_cond_order_scenes1 = possible_dynamic_conds(randperm(length(possible_dynamic_conds)));
    dynamic_cond_order_scenes2 = possible_dynamic_conds(randperm(length(possible_dynamic_conds)));

    hands_dynamic_cond_index = 1;
    faces_dynamic_cond_index = 1;
    bodies_dynamic_cond_index = 1;
    animals_dynamic_cond_index = 1;
    objects1_dynamic_cond_index = 1;
    objects2_dynamic_cond_index = 1;
    scenes1_dynamic_cond_index = 1;
    scenes2_dynamic_cond_index = 1;
    

    % make a matrix full of category condition names
    for i = 1:length(block_conds) %
    
        if block_conds(i, run_num) == 0
            condition_names{i, run_num} = 'baseline';
            block_conds_all{i, run_num} = 0;
        end
    
        if block_conds(i, run_num) == 1
            if dynamic_cond_order_faces(faces_dynamic_cond_index) == 0
                condition_names{i, run_num} = 'baseline';
                block_conds_all{i, run_num}= 0;
            end
            if dynamic_cond_order_faces(faces_dynamic_cond_index) == 1
                condition_names{i, run_num} = 'faces-normal';
                block_conds_all{i, run_num}= 1;
            end
            if dynamic_cond_order_faces(faces_dynamic_cond_index) == 2
                condition_names{i, run_num} = 'faces-linear';
                block_conds_all{i, run_num} = 2;
            end
            if dynamic_cond_order_faces(faces_dynamic_cond_index) == 3
                condition_names{i, run_num} = 'faces-still';
                block_conds_all{i, run_num} = 3;
            end
            faces_dynamic_cond_index = faces_dynamic_cond_index+1;
        end
    
        if block_conds(i, run_num) == 2
            if dynamic_cond_order_hands(hands_dynamic_cond_index) == 0
                condition_names{i, run_num} = 'baseline';
                block_conds_all{i, run_num} = 0;
            end
            if dynamic_cond_order_hands(hands_dynamic_cond_index) == 1
                condition_names{i, run_num} = 'hands-normal';
                block_conds_all{i, run_num} = 4;
            end
            if dynamic_cond_order_hands(hands_dynamic_cond_index) == 2
                condition_names{i, run_num} = 'hands-linear';
                block_conds_all{i, run_num} = 5;
            end
            if dynamic_cond_order_hands(hands_dynamic_cond_index) == 3
                condition_names{i, run_num} = 'hands-still';
                block_conds_all{i, run_num} = 6;
            end
            hands_dynamic_cond_index = hands_dynamic_cond_index+1;
        end
    
        if block_conds(i, run_num) == 3
            if dynamic_cond_order_bodies(bodies_dynamic_cond_index) == 0
                condition_names{i, run_num} = 'baseline';
                block_conds_all{i, run_num} = 0;
            end
            if dynamic_cond_order_bodies(bodies_dynamic_cond_index) == 1
                condition_names{i, run_num} = 'bodies-normal';
                block_conds_all{i, run_num} = 7;
            end
            if dynamic_cond_order_bodies(bodies_dynamic_cond_index) == 2
                condition_names{i, run_num} = 'bodies-linear';
                block_conds_all{i, run_num} = 8;
            end
            if dynamic_cond_order_bodies(bodies_dynamic_cond_index) == 3
                condition_names{i, run_num} = 'bodies-still';
                block_conds_all{i, run_num} = 9;
            end
            bodies_dynamic_cond_index = bodies_dynamic_cond_index+1;
        end
    
        if block_conds(i, run_num) == 4
            if dynamic_cond_order_animals(animals_dynamic_cond_index) == 0
                condition_names{i, run_num} = 'baseline';
                block_conds_all{i, run_num} = 0;
            end
            if dynamic_cond_order_animals(animals_dynamic_cond_index) == 1
                condition_names{i, run_num} = 'animals-normal';
                block_conds_all{i, run_num} = 10;
            end
            if dynamic_cond_order_animals(animals_dynamic_cond_index) == 2
                condition_names{i, run_num} = 'animals-linear';
                block_conds_all{i, run_num} = 11;
            end
            if dynamic_cond_order_animals(animals_dynamic_cond_index) == 3
                condition_names{i, run_num} = 'animals-still';
                block_conds_all{i, run_num} = 12;
            end
            animals_dynamic_cond_index = animals_dynamic_cond_index+1;
        end
    
        if block_conds(i, run_num) == 5
            if dynamic_cond_order_objects1(objects1_dynamic_cond_index) == 0
                condition_names{i, run_num} = 'baseline';
                block_conds_all{i, run_num} = 0;
            end
            if dynamic_cond_order_objects1(objects1_dynamic_cond_index) == 1
                condition_names{i, run_num} = 'objects1-normal';
                block_conds_all{i, run_num} = 13;
            end
            if dynamic_cond_order_objects1(objects1_dynamic_cond_index) == 2
                condition_names{i, run_num} = 'objects1-linear';
                block_conds_all{i, run_num} = 14;
            end
            if dynamic_cond_order_objects1(objects1_dynamic_cond_index) == 3
                condition_names{i, run_num} = 'objects1-still';
                block_conds_all{i, run_num} = 15;
            end
            objects1_dynamic_cond_index = objects1_dynamic_cond_index+1;
        end
    
        if block_conds(i, run_num) == 6
            if dynamic_cond_order_objects2(objects2_dynamic_cond_index) == 0
                condition_names{i, run_num} = 'baseline';
                block_conds_all{i, run_num} = 0;
            end
            if dynamic_cond_order_objects2(objects2_dynamic_cond_index) == 1
                condition_names{i, run_num} = 'objects2-normal';
                block_conds_all{i, run_num} = 16;
            end
            if dynamic_cond_order_objects2(objects2_dynamic_cond_index) == 2
                condition_names{i, run_num} = 'objects2-linear';
                block_conds_all{i, run_num} = 17;
            end
            if dynamic_cond_order_objects2(objects2_dynamic_cond_index) == 3
                condition_names{i, run_num} = 'objects2-still';
                block_conds_all{i, run_num} = 18;
            end
            objects2_dynamic_cond_index = objects2_dynamic_cond_index+1;
        end
    
        if block_conds(i, run_num) == 7
            if dynamic_cond_order_scenes1(scenes1_dynamic_cond_index) == 0
                condition_names{i, run_num} = 'baseline';
                block_conds_all{i, run_num} = 0;
            end
            if dynamic_cond_order_scenes1(scenes1_dynamic_cond_index) == 1
                condition_names{i, run_num} = 'scenes1-normal';
                block_conds_all{i, run_num} = 19;
            end
            if dynamic_cond_order_scenes1(scenes1_dynamic_cond_index) == 2
                condition_names{i, run_num} = 'scenes1-linear';
                block_conds_all{i, run_num} = 20;
            end
            if dynamic_cond_order_scenes1(scenes1_dynamic_cond_index) == 3
                condition_names{i, run_num} = 'scenes1-still';
                block_conds_all{i, run_num} = 21;
            end
            scenes1_dynamic_cond_index = scenes1_dynamic_cond_index+1;
        end
    
        if block_conds(i, run_num) == 8
            if dynamic_cond_order_scenes2(scenes2_dynamic_cond_index) == 0
                condition_names{i, run_num} = 'baseline';
                block_conds_all{i, run_num} = 0;
            end
            if dynamic_cond_order_scenes2(scenes2_dynamic_cond_index) == 1
                condition_names{i, run_num} = 'scenes2-normal';
                block_conds_all{i, run_num} = 22;
            end
            if dynamic_cond_order_scenes2(scenes2_dynamic_cond_index) == 2
                condition_names{i, run_num} = 'scenes2-linear';
                block_conds_all{i, run_num} = 23;
            end
            if dynamic_cond_order_scenes2(scenes2_dynamic_cond_index) == 3
                condition_names{i, run_num} = 'scenes2-still';
                block_conds_all{i, run_num} = 24;
            end
            scenes2_dynamic_cond_index = scenes2_dynamic_cond_index+1;
        end
    
    end


dynamic_conditions = seq.stim_dynamic_conditions(1:3); %remove baseline from dynamic conditions list
                      
% load stimuli in condition orders
stim_dir = fullfile(seq.exp_dir, seq.background);
sequence_stim_names = {};

for category_index = 1:seq.num_categories
    curr_cateogry = char(seq.stim_category_conditions(category_index));

    %initalize category stim array
    category_stim = cell(seq.stim_per_condition,length(dynamic_conditions));
    
    %intialize condition actors array
    condition_actors = [];
    
    for i = 1:length(dynamic_conditions)
           
        %find directory
        dynamic_cond = dynamic_conditions(i);
        cond_dir = [curr_cateogry, '-', char(dynamic_cond)];
        stim_file_path = char(fullfile(stim_dir, curr_cateogry, cond_dir));
    
        %load stim files
        stim_files = dir(fullfile(stim_file_path, '*.mp4'));
    
        %choose 2 stim files for the dynamic condition
        unique_dynamics_actors = false;
        dynamic_condition_actors = cell(seq.stim_per_condition,1);
        while unique_dynamics_actors == false

            stim_not_in_previous_runs = false;
            while stim_not_in_previous_runs == false
          
                rand_stim_indices = randperm(numel(stim_files), seq.stim_per_condition);
                random_stim = stim_files(rand_stim_indices);
        
                for rand_stim_index = 1:length(random_stim)
                    random_stim_name = random_stim(rand_stim_index).name;
                    curr_actor = extractBefore(random_stim_name, '-');
                    dynamic_condition_actors{rand_stim_index} = curr_actor;
                end
                %check to see if stim are already in a previous run
                if exist('stim_names', 'var') == 1
                    stim_name_1 = random_stim(1);
                    stim_name_2 = random_stim(2);
                    
                    stim_name1_in_previous_run = ismember(stim_name_1.name, stim_names);
                    stim_name2_in_previous_run = ismember(stim_name_2.name, stim_names);

                    if ~stim_name1_in_previous_run && ~stim_name2_in_previous_run
                        stim_not_in_previous_runs = true;
                    else
                        stim_not_in_previous_runs = false;
                    end

                    % for stim_num = 1:length(random_stim)
                    %     curr_stim_name = random_stim(stim_num).name;
                    %     if ~ismember(curr_stim_name, stim_names)
                    %         stim_not_in_previous_runs = true;
                    %     end
                    %     if ismember(curr_stim_name, stim_names)
                    %         disp(['stim name are in previous run: ' curr_stim_name])
                    %     end
                    % end
                   
                elseif ~exist('stim_names', 'var') == 1
                    stim_not_in_previous_runs = true;
                end
            end
           %make sure no stimuli per cateogry have the same actors/exemplars
           common_actors = intersect(condition_actors, dynamic_condition_actors);
           if isempty(common_actors)
               if length(unique(dynamic_condition_actors)) == length(dynamic_condition_actors)
                   for ii = 1:length(random_stim)
                       stim_name = random_stim(ii).name;
                       category_stim{ii, i} = stim_name;
                   end

                   condition_actors = vertcat(condition_actors,  dynamic_condition_actors);
                   unique_dynamics_actors = true;
    
               end
           end
        end
    end

    sequence_stim_names =  vertcat(sequence_stim_names, category_stim);

    end



    %disp(sequence_stim_names);
    stim_names_list = reshape(sequence_stim_names, [], 1);


    
    %put stim names into condition order
    faces_normal_index = 1;
    faces_scrambled_index = 1;
    faces_linear_index = 1;
    faces_still_index = 1;

    hands_normal_index = 1;
    hands_scrambled_index = 1;
    hands_linear_index = 1;
    hands_still_index = 1;

    bodies_normal_index = 1;
    bodies_scrambled_index = 1;
    bodies_linear_index = 1;
    bodies_still_index = 1;

    animals_normal_index = 1;
    animals_scrambled_index = 1;
    animals_linear_index = 1;
    animals_still_index = 1;

    objects1_normal_index = 1;
    objects1_scrambled_index = 1;
    objects1_linear_index = 1;
    objects1_still_index = 1;

    objects2_normal_index = 1;
    objects2_scrambled_index = 1;
    objects2_linear_index = 1;
    objects2_still_index = 1;

    scenes1_normal_index = 1;
    scenes1_scrambled_index = 1;
    scenes1_linear_index = 1;
    scenes1_still_index = 1;

    scenes2_normal_index = 1;
    scenes2_scrambled_index = 1;
    scenes2_linear_index = 1;
    scenes2_still_index = 1;

     for i = 1:length(condition_names(:,run_num)) %changed to cond names with task
        curr_condition = char(condition_names(i,run_num));

        if strcmp(curr_condition, 'baseline')
            cur_file_name = 'baseline';
        else
            %faces
            if strcmp(curr_condition, 'faces-normal')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'faces-normal'));
                cur_file_name = matching_stim_names{faces_normal_index};
                faces_normal_index = faces_normal_index + 1;
            end
            if strcmp(curr_condition, 'faces-scrambled')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'faces-scrambled'));
                cur_file_name = matching_stim_names{faces_scrambled_index};
                faces_scrambled_index = faces_scrambled_index + 1;
            end
            if strcmp(curr_condition, 'faces-linear')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'faces-linear'));
                cur_file_name = matching_stim_names{faces_linear_index};
                faces_linear_index = faces_linear_index + 1;
            end
            if strcmp(curr_condition, 'faces-still')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'faces-still'));
                cur_file_name = matching_stim_names{faces_still_index};
                faces_still_index = faces_still_index + 1;
            end

            %hands
            if strcmp(curr_condition, 'hands-normal')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'hands-normal'));
                cur_file_name = matching_stim_names{hands_normal_index};
                hands_normal_index = hands_normal_index + 1;
            end
            if strcmp(curr_condition, 'hands-scrambled')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'hands-scrambled'));
                cur_file_name = matching_stim_names{hands_scrambled_index};
                hands_scrambled_index = hands_scrambled_index + 1;
            end
            if strcmp(curr_condition, 'hands-linear')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'hands-linear'));
                cur_file_name = matching_stim_names{hands_linear_index};
                hands_linear_index = hands_linear_index + 1;
            end
            if strcmp(curr_condition, 'hands-still')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'hands-still'));
                cur_file_name = matching_stim_names{hands_still_index};
                hands_still_index = hands_still_index + 1;
            end

            %bodies
            if strcmp(curr_condition, 'bodies-normal')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'bodies-normal'));
                cur_file_name = matching_stim_names{bodies_normal_index};
                bodies_normal_index = bodies_normal_index + 1;
            end
            if strcmp(curr_condition, 'bodies-scrambled')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'bodies-scrambled'));
                cur_file_name = matching_stim_names{bodies_scrambled_index};
                bodies_scrambled_index = bodies_scrambled_index + 1;
            end
            if strcmp(curr_condition, 'bodies-linear')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'bodies-linear'));
                cur_file_name = matching_stim_names{bodies_linear_index};
                bodies_linear_index = bodies_linear_index + 1;
            end
            if strcmp(curr_condition, 'bodies-still')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'bodies-still'));
                cur_file_name = matching_stim_names{bodies_still_index};
                bodies_still_index = bodies_still_index + 1;
            end

            %animals
            if strcmp(curr_condition, 'animals-normal')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'animals-normal'));
                cur_file_name = matching_stim_names{animals_normal_index};
                animals_normal_index = animals_normal_index + 1;
            end
            if strcmp(curr_condition, 'animals-scrambled')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'animals-scrambled'));
                cur_file_name = matching_stim_names{animals_scrambled_index};
                animals_scrambled_index = animals_scrambled_index + 1;
            end
            if strcmp(curr_condition, 'animals-linear')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'animals-linear'));
                cur_file_name = matching_stim_names{animals_linear_index};
                animals_linear_index = animals_linear_index + 1;
            end
            if strcmp(curr_condition, 'animals-still')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'animals-still'));
                cur_file_name = matching_stim_names{animals_still_index};
                animals_still_index = animals_still_index + 1;
            end

            %objects1
            if strcmp(curr_condition, 'objects1-normal')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'objects1-normal'));
                cur_file_name = matching_stim_names{objects1_normal_index};
                objects1_normal_index = objects1_normal_index + 1;
            end
            if strcmp(curr_condition, 'objects1-scrambled')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'objects1-scrambled'));
                cur_file_name = matching_stim_names{objects1_scrambled_index};
                objects1_scrambled_index = objects1_scrambled_index + 1;
            end
            if strcmp(curr_condition, 'objects1-linear')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'objects1-linear'));
                cur_file_name = matching_stim_names{objects1_linear_index};
                objects1_linear_index = objects1_linear_index + 1;
            end
            if strcmp(curr_condition, 'objects1-still')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'objects1-still'));
                cur_file_name = matching_stim_names{objects1_still_index};
                objects1_still_index = objects1_still_index + 1;
            end

            %objects2
            if strcmp(curr_condition, 'objects2-normal')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'objects2-normal'));
                cur_file_name = matching_stim_names{objects2_normal_index};
                objects2_normal_index = objects2_normal_index + 1;
            end
            if strcmp(curr_condition, 'objects2-scrambled')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'objects2-scrambled'));
                cur_file_name = matching_stim_names{objects2_scrambled_index};
                objects2_scrambled_index = objects2_scrambled_index + 1;
            end
            if strcmp(curr_condition, 'objects2-linear')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'objects2-linear'));
                cur_file_name = matching_stim_names{objects2_linear_index};
                objects2_linear_index = objects2_linear_index + 1;
            end
            if strcmp(curr_condition, 'objects2-still')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'objects2-still'));
                cur_file_name = matching_stim_names{objects2_still_index};
                objects2_still_index = objects2_still_index + 1;
            end

            %scenes1
            if strcmp(curr_condition, 'scenes1-normal')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'scenes1-normal'));
                cur_file_name = matching_stim_names{scenes1_normal_index};
                scenes1_normal_index = scenes1_normal_index + 1;
            end
            if strcmp(curr_condition, 'scenes1-scrambled')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'scenes1-scrambled'));
                cur_file_name = matching_stim_names{scenes1_scrambled_index};
                scenes1_scrambled_index = scenes1_scrambled_index + 1;
            end
            if strcmp(curr_condition, 'scenes1-linear')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'scenes1-linear'));
                cur_file_name = matching_stim_names{scenes1_linear_index};
                scenes1_linear_index = scenes1_linear_index + 1;
            end
            if strcmp(curr_condition, 'scenes1-still')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'scenes1-still'));
                cur_file_name = matching_stim_names{scenes1_still_index};
                scenes1_still_index = scenes1_still_index + 1;
            end

            %scenes2
            if strcmp(curr_condition, 'scenes2-normal')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'scenes2-normal'));
                cur_file_name = matching_stim_names{scenes2_normal_index};
                scenes2_normal_index = scenes2_normal_index + 1;
            end
            if strcmp(curr_condition, 'scenes2-scrambled')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'scenes2-scrambled'));
                cur_file_name = matching_stim_names{scenes2_scrambled_index};
                scenes2_scrambled_index = scenes2_scrambled_index + 1;
            end
            if strcmp(curr_condition, 'scenes2-linear')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'scenes2-linear'));
                cur_file_name = matching_stim_names{scenes2_linear_index};
                scenes2_linear_index = scenes2_linear_index + 1;
            end
            if strcmp(curr_condition, 'scenes2-still')
                matching_stim_names = sequence_stim_names(contains(sequence_stim_names, 'scenes2-still'));
                cur_file_name = matching_stim_names{scenes2_still_index};
                scenes2_still_index = scenes2_still_index + 1;
            end
        end
        stim_names{i, run_num} = cur_file_name;
     end

    
    %choose and insert task trials
    %get conditions to repeat
    are_task_repeats_valid = false;
    while are_task_repeats_valid == false
        task_repeat_conditions = randperm(length(seq.conditions) - 3, seq.num_task_repeats) + 2; %1-33 - 3 = 1-30 + 2 = 3-32
        task_repeat_conditions_indices = [];

        for i = 1:length(task_repeat_conditions)
            task_repeat_condition_num = task_repeat_conditions(i);
            stim_names_for_run = stim_names(:, run_num);
            
            curr_repeat_condition = seq.conditions{task_repeat_condition_num};
            possible_task_stim = stim_names_for_run(contains(stim_names_for_run, curr_repeat_condition));
            chosen_task_stim = possible_task_stim(randi(seq.stim_per_condition));
            task_repeat_condition_index = find(strcmp(stim_names_for_run, chosen_task_stim));
    
            task_repeat_conditions_indices = [task_repeat_conditions_indices; task_repeat_condition_index];
            
        end
        if max(task_repeat_conditions_indices) < (length(block_conds_all) - seq.max_task_repeat_distance) %make sure that the chosen repeat stimuli can't be inserted past the length of the run 
            are_task_repeats_valid = true;
        end
        task_repeat_conditions_indices = sort(task_repeat_conditions_indices); %sort indices in ascending order
    end

    %put task repeat stim in array but in the sorted ascending order
    task_repeat_stim = [];
    for i = 1:length(task_repeat_conditions_indices)
        index = task_repeat_conditions_indices(i);
        curr_stim = stim_names_for_run(index);
        task_repeat_stim = [task_repeat_stim; curr_stim];
    end
    seq.task_repeat_stimuli(:, run_num) = task_repeat_stim; %save task stimuli across runs
    

    working_array_condition_names = condition_names(:, run_num);
    working_array_block_conds_all = block_conds_all(:, run_num);
    working_array_stim_names = stim_names(:, run_num);
    for i = 1:length(task_repeat_conditions_indices)
        curr_task_repeat_condition_index = task_repeat_conditions_indices(i);
        curr_task_repeat_stim = task_repeat_stim(i);

        %insert task repeats into block_conds_all, condition_names, and stim_names
        distance_to_add = randi([2 seq.max_task_repeat_distance]); %add random distance between at least 1 stim between the original and repeat to set max distance
        task_repeat_insert_index = task_repeat_conditions_indices(i) + distance_to_add; %insert repeat after the stimuli before the repeat index + added distance
        
        working_array_block_conds_all = [working_array_block_conds_all(1:task_repeat_insert_index); 25; working_array_block_conds_all(task_repeat_insert_index+1:end)];
        working_array_condition_names = [working_array_condition_names(1:task_repeat_insert_index); 'task_repeat'; working_array_condition_names(task_repeat_insert_index+1:end)];
        working_array_stim_names = [working_array_stim_names(1:task_repeat_insert_index); curr_task_repeat_stim; working_array_stim_names(task_repeat_insert_index+1:end)];

        seq.task_repeat_stimuli_indices{i, run_num} = task_repeat_insert_index + 1;
    end
    condition_names_with_task(:, run_num) = working_array_condition_names;
    block_conds_all_with_task(:, run_num) = working_array_block_conds_all;
    stim_names_with_task(:, run_num) = working_array_stim_names;

   
end

seq.condition_names = condition_names_with_task;
seq.block_conds_all = block_conds_all_with_task;
seq.stim_names = stim_names_with_task;

disp(seq.stim_names)
disp(seq.task_repeat_stimuli)



for run_num = 1:seq.num_runs

    for i = 1:length(seq.stim_names)
        if contains(seq.stim_names{i, run_num}, 'baseline')
            stim_directories{i, run_num} = baseline_dir;
        else
            cat_dir = extractBetween(seq.stim_names{i, run_num}, '_', '-');
            
            %get dynamic condition directory
            dynamic_cond = extractBetween(seq.stim_names{i, run_num}, '-', '~');
            dynamic_dir = [char(cat_dir) '-' char(dynamic_cond)];
            video_file_path = char(fullfile(stim_dir, cat_dir, dynamic_dir, seq.stim_names{i, run_num}));
            
            % check if the file exists
            if exist(video_file_path, 'file') ~= 2
                % if the file does not exist, throw an error
                error(['File does not exist:    ' video_file_path]);
            end
            
            stim_directories{i, run_num} = video_file_path;
        
        end
    end
end


disp(stim_directories);


%save CSVs for psychopy script
psychopy_sequence_folder_filepath = '/Users/beth/Desktop/DynaCat/DynaCat_PsychoPy/data';
sequence_orders_folder_name = [participant_code '_sequence_orders'];
psychopy_sequence_subject_data_folder_filepath = fullfile(psychopy_sequence_folder_filepath, participant_code, sequence_orders_folder_name);

if ~exist(psychopy_sequence_subject_data_folder_filepath, 'dir')
   mkdir(psychopy_sequence_subject_data_folder_filepath)
end

stim_names_filename = [participant_code '_stim-names.csv'];
writecell(seq.stim_names,fullfile(psychopy_sequence_subject_data_folder_filepath, stim_names_filename))

stim_dir_filename = [participant_code '_stim-directories.csv'];
writecell(stim_directories,fullfile(psychopy_sequence_subject_data_folder_filepath, stim_dir_filename))

block_conds_all_filename = [participant_code '_block-conds-all.csv'];
writecell(block_conds_all_with_task,fullfile(psychopy_sequence_subject_data_folder_filepath, block_conds_all_filename))

task_repeat_stimuli_filename = [participant_code '_task-repeat-stimuli.csv'];
writecell(seq.task_repeat_stimuli,fullfile(psychopy_sequence_subject_data_folder_filepath, task_repeat_stimuli_filename))

condition_names_filename = [participant_code '_condition-names.csv'];
writecell(seq.condition_names,fullfile(psychopy_sequence_subject_data_folder_filepath, condition_names_filename))


