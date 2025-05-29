:- dynamic(user_crops/1).


% Crop(crop_name, NitrogenLevel, SoilHealth,Pesticide,Yield)
crop(corn, -50, medium, low, 150).
crop(soybeans, 80, high, medium, 45).
crop(wheat, -30, medium, high, 60).
crop(cotton, -60, low, low, 800).
crop(alfalfa, 100, high, high, 6).
crop(clover, 90, high, medium, 4).
crop(barley, -25, medium, medium, 70).
crop(oats, -20, medium, high, 80).
crop(rice, -40, low, medium, 120).
crop(beans, 70, high, low, 35).

excellent_sequence(corn, soybeans).
excellent_sequence(cotton, clover).
excellent_sequence(wheat, alfalfa).
excellent_sequence(soybeans, wheat).
excellent_sequence(clover, corn).

good_sequence(beans, wheat).
good_sequence(alfalfa, corn).
good_sequence(barley, soybeans).
good_sequence(oats, beans).
good_sequence(rice, clover).
poor_sequence(corn, cotton).
poor_sequence(cotton, rice).
poor_sequence(wheat, barley).

terrible_sequence(X, X).

get_all_crops(Crops) :-

    findall(Name, crop(Name, _, _, _, _), Crops).

get_crop_info(CropName, Nitrogen, Soil, Pest, Yield) :-
    crop(CropName, Nitrogen, Soil, Pest, Yield).

find_best_rotation(CropList, NumCrops, BestSequence, BestScore) :-
    retractall(user_crops(_)),
    assert(user_crops(CropList)),
    validate_crops(CropList),

    findall(Sequence,
            generate_sequence(CropList, NumCrops, Sequence),
            AllSequences),

    evaluate_sequences(AllSequences, BestSequence, BestScore).

validate_crops([]).
validate_crops([Crop|Rest]) :-
    crop(Crop, _, _, _, _),
    validate_crops(Rest).

generate_sequence(AvailableCrops, NumCrops, Sequence) :-
    length(Sequence, NumCrops),
    fill_sequence(Sequence, AvailableCrops).

fill_sequence([], _).
fill_sequence([Crop|Rest], AvailableCrops) :-
    member(Crop, AvailableCrops),
    fill_sequence(Rest, AvailableCrops).

evaluate_sequences([], none, -999).
evaluate_sequences([Sequence|Rest], BestSequence, BestScore) :-
    calculate_sequence_score(Sequence, Score),
    evaluate_sequences(Rest, RestBest, RestScore),
    (Score > RestScore ->
        BestSequence = Sequence, BestScore = Score
    ;
        BestSequence = RestBest, BestScore = RestScore
    ).

calculate_sequence_score(Sequence, TotalScore) :-
    calculate_pairs_score(Sequence, 0, TotalScore).

calculate_pairs_score([], Score, Score).
calculate_pairs_score([_], Score, Score).
calculate_pairs_score([Crop1, Crop2|Rest], AccScore, TotalScore) :-
    score_crop_pair(Crop1, Crop2, PairScore),
    NewScore is AccScore + PairScore,
    calculate_pairs_score([Crop2|Rest], NewScore, TotalScore).

score_crop_pair(Crop1, Crop2, Score) :-
    (excellent_sequence(Crop1, Crop2) ->
        BaseScore = 100
    ; good_sequence(Crop1, Crop2) ->
        BaseScore = 50
    ; poor_sequence(Crop1, Crop2) ->
        BaseScore = -30
    ; terrible_sequence(Crop1, Crop2) ->
        BaseScore = -100
    ;
        BaseScore = 0
    ),

    crop(Crop1, N1, _, _, _),
    crop(Crop2, N2, _, _, _),
    nitrogen_balance_score(N1, N2, NitrogenScore),

    crop(Crop1, _, S1, _, _),
    crop(Crop2, _, S2, _, _),
    soil_health_score(S1, S2, SoilScore),

    Score is BaseScore + NitrogenScore + SoilScore.

nitrogen_balance_score(N1, N2, Score) :-
    (N1 < -40, N2 > 60 ->
        Score = 30
    ; N1 < -20, N2 > 40 ->
        Score = 20
    ; N1 < -40, N2 < -40 ->
        Score = -25
    ;
        Score = 0
    ).

soil_health_score(low, high, 25).
soil_health_score(medium, high, 15).
soil_health_score(high, low, -20).
soil_health_score(_, _, 0).


show_all_crops :-
    write('Available crops:'), nl,
    crop(Name, N, S, P, Y),
    write('- '), write(Name),
    write(' (Nitrogen: '), write(N),
    write(', Soil: '), write(S),
    write(', Pest: '), write(P),
    write(', Yield: '), write(Y), write(')'), nl,
    fail.
show_all_crops.



