
   table_name   | count                                                                                                                                                      
----------------+-------
 bibliotheque   | 15674
 college        |  9157
 commune        | 34968
 departement    |   108
 ehpad          |  7422
 entreprise_btp |  9284
 festivals      |  6677
 lycee          |  5578
 mairie         | 34968
 pharmacie      | 20454
 region         |    25
(11 rows)


                   region                    | nb_communes                                                                                                                   
---------------------------------------------+-------------
 Grand Est                                   |        5115
 Occitanie                                   |        4446
 Nouvelle-Aquitaine                          |        4293
 Auvergne-Rh¶ne-Alpes                        |        4025
 Hauts-de-France                             |        3782
 Bourgogne-Franche-ComtÚ                     |        3685
 Normandie                                   |        2644
 Centre-Val de Loire                         |        1754
 ╬le-de-France                               |        1266
 Pays de la Loire                            |        1228
 Bretagne                                    |        1202
 Provence-Alpes-C¶te d'Azur                  |         946
 Corse                                       |         360
 PolynÚsie franþaise                         |          48
 Martinique                                  |          34
 Nouvelle-CalÚdonie                          |          33
 Guadeloupe                                  |          32
 La RÚunion                                  |          24
 Guyane                                      |          22
 Mayotte                                     |          17
 Terres australes et antarctiques franþaises |           5
 Wallis et Futuna                            |           3
 Saint-Pierre-et-Miquelon                    |           2
 Saint-Martin                                |           1
 Saint-BarthÚlemy                            |           1
(25 rows)


                 departement                 | nb_communes                                                                                                                   
---------------------------------------------+-------------
 Pas-de-Calais                               |         887
 Aisne                                       |         797
 Somme                                       |         771
 Moselle                                     |         725
 Seine-Maritime                              |         707
 C¶te-d'Or                                   |         698
 Oise                                        |         680
 Nord                                        |         647
 Marne                                       |         610
 Meurthe-et-Moselle                          |         591
 Haute-Garonne                               |         586
 Eure                                        |         585
 Doubs                                       |         563
 Sa¶ne-et-Loire                              |         563
 PyrÚnÚes-Atlantiques                        |         545
 Haute-Sa¶ne                                 |         536
 Gironde                                     |         534
 Calvados                                    |         526
 Bas-Rhin                                    |         514
 IsÞre                                       |         512
 Seine-et-Marne                              |         507
 Vosges                                      |         506
 Dordogne                                    |         503
 Meuse                                       |         499
 Jura                                        |         492
 Hautes-PyrÚnÚes                             |         469
 Puy-de-D¶me                                 |         463
 Charente-Maritime                           |         462
 Gers                                        |         458
 Ardennes                                    |         447
 Manche                                      |         445
 Aude                                        |         433
^CCancel request sent                                                                                                                                                          
(.env) PS C:\Users\Utilisateur\Desktop\cours\megabase-corrige0-two-sources> psql -U postgres -d megabase0 -f analyse.sql
Password for user postgres: 

   table_name   | count                                                                                                                                                        
----------------+-------
 bibliotheque   | 15674
 college        |  9157
 commune        | 34968
 departement    |   108
 ehpad          |  7422
 entreprise_btp |  9284
 festivals      |  6677
 lycee          |  5578
 mairie         | 34968
 pharmacie      | 20454
 region         |    25
(11 rows)


                   region                    | nb_communes                                                                                                                     
---------------------------------------------+-------------
 Grand Est                                   |        5115
 Occitanie                                   |        4446
 Nouvelle-Aquitaine                          |        4293
 Auvergne-Rh¶ne-Alpes                        |        4025
 Hauts-de-France                             |        3782
 Bourgogne-Franche-ComtÚ                     |        3685
 Normandie                                   |        2644
 Centre-Val de Loire                         |        1754
 ╬le-de-France                               |        1266
 Pays de la Loire                            |        1228
 Bretagne                                    |        1202
 Provence-Alpes-C¶te d'Azur                  |         946
 Corse                                       |         360
 PolynÚsie franþaise                         |          48
 Martinique                                  |          34
 Nouvelle-CalÚdonie                          |          33
 Guadeloupe                                  |          32
 La RÚunion                                  |          24
 Guyane                                      |          22
 Mayotte                                     |          17
 Terres australes et antarctiques franþaises |           5
 Wallis et Futuna                            |           3
 Saint-Pierre-et-Miquelon                    |           2
 Saint-Martin                                |           1
 Saint-BarthÚlemy                            |           1
(25 rows)


                 departement                 | nb_communes                                                                                                                     
---------------------------------------------+-------------
 Pas-de-Calais                               |         887
 Aisne                                       |         797
 Somme                                       |         771
 Moselle                                     |         725
 Seine-Maritime                              |         707
 C¶te-d'Or                                   |         698
 Oise                                        |         680
 Nord                                        |         647
 Marne                                       |         610
 Meurthe-et-Moselle                          |         591
 Haute-Garonne                               |         586
 Eure                                        |         585
 Doubs                                       |         563
 Sa¶ne-et-Loire                              |         563
 PyrÚnÚes-Atlantiques                        |         545
 Haute-Sa¶ne                                 |         536
 Gironde                                     |         534
 Calvados                                    |         526
 Bas-Rhin                                    |         514
 IsÞre                                       |         512
 Seine-et-Marne                              |         507
 Vosges                                      |         506
 Dordogne                                    |         503
 Meuse                                       |         499
 Jura                                        |         492
 Hautes-PyrÚnÚes                             |         469
 Puy-de-D¶me                                 |         463
 Charente-Maritime                           |         462
 Gers                                        |         458
 Ardennes                                    |         447
 Manche                                      |         445
 Aude                                        |         433
 Aube                                        |         431
 Haute-Marne                                 |         426
 Yonne                                       |         423
 Ain                                         |         391
 Orne                                        |         381
 Haut-Rhin                                   |         366                                                                                                                     
 Eure-et-Loir                                |         363                                                                                                                     
 Dr¶me                                       |         362                                                                                                                     
 Charente                                    |         359                                                                                                                     
 Sarthe                                      |         352                                                                                                                     
 Gard                                        |         350                                                                                                                     
 C¶tes-d'Armor                               |         344                                                                                                                     
 HÚrault                                     |         341                                                                                                                     
 ArdÞche                                     |         335                                                                                                                     
 Ille-et-Vilaine                             |         332                                                                                                                     
 Landes                                      |         327                                                                                                                     
 Loiret                                      |         325                                                                                                                     
 AriÞge                                      |         325                                                                                                                     
 Loire                                       |         320                                                                                                                     
 Lot-et-Garonne                              |         319                                                                                                                     
 Allier                                      |         317                                                                                                                     
 Tarn                                        |         314                                                                                                                     
 Lot                                         |         312                                                                                                                     
 NiÞvre                                      |         309                                                                                                                     
 Cher                                        |         286                                                                                                                     
 Aveyron                                     |         285                                                                                                                     
 Haute-Savoie                                |         279                                                                                                                     
 CorrÞze                                     |         277                                                                                                                     
 FinistÞre                                   |         277                                                                                                                     
 Savoie                                      |         273                                                                                                                     
 Indre-et-Loire                              |         272                                                                                                                     
 Loir-et-Cher                                |         267                                                                                                                     
 Rh¶ne                                       |         266                                                                                                                     
 Vienne                                      |         265                                                                                                                     
 Yvelines                                    |         259                                                                                                                     
 Haute-Loire                                 |         257                                                                                                                     
 Creuse                                      |         255                                                                                                                     
 VendÚe                                      |         253                                                                                                                     
 Deux-SÞvres                                 |         252                                                                                                                     
 Cantal                                      |         250                                                                                                                     
 Morbihan                                    |         249                                                                                                                     
 Indre                                       |         241                                                                                                                     
 Mayenne                                     |         240                                                                                                                     
 Haute-Corse                                 |         236                                                                                                                     
 PyrÚnÚes-Orientales                         |         226                                                                                                                     
 Loire-Atlantique                            |         207                                                                                                                     
 Alpes-de-Haute-Provence                     |         198                                                                                                                     
 Tarn-et-Garonne                             |         195                                                                                                                     
 Haute-Vienne                                |         195                                                                                                                     
 Essonne                                     |         194                                                                                                                     
 Val-d'Oise                                  |         183                                                                                                                     
 Maine-et-Loire                              |         176                                                                                                                     
 Alpes-Maritimes                             |         163                                                                                                                     
 Hautes-Alpes                                |         162                                                                                                                     
 Var                                         |         153                                                                                                                     
 LozÞre                                      |         152                                                                                                                     
 Vaucluse                                    |         151                                                                                                                     
 Corse-du-Sud                                |         124                                                                                                                     
 Bouches-du-Rh¶ne                            |         119                                                                                                                     
 Territoire de Belfort                       |         101                                                                                                                     
 PolynÚsie franþaise                         |          48                                                                                                                     
 Val-de-Marne                                |          47                                                                                                                     
 Seine-Saint-Denis                           |          39                                                                                                                     
 Hauts-de-Seine                              |          36                                                                                                                     
 Martinique                                  |          34                                                                                                                     
 Nouvelle-CalÚdonie                          |          33                                                                                                                     
 Guadeloupe                                  |          32                                                                                                                     
 La RÚunion                                  |          24                                                                                                                     
 Guyane                                      |          22                                                                                                                     
 Mayotte                                     |          17                                                                                                                     
 Terres australes et antarctiques franþaises |           5                                                                                                                     
 Wallis et Futuna                            |           3                                                                                                                     
 Saint-Pierre-et-Miquelon                    |           2                                                                                                                     
 Saint-Martin                                |           1                                                                                                                     
 Saint-BarthÚlemy                            |           1                                                                                                                     
 Paris                                       |           1                                                                                                                     
(108 rows)                                                                                                                                                                     
                                                                                                                                                                               
                                                                                                                                                                               
                 departement                 | nb_bibliotheques | nb_colleges | nb_ehpads | nb_entreprises_btp | nb_festivals | nb_lycees | nb_mairies | nb_pharmacies         
---------------------------------------------+------------------+-------------+-----------+--------------------+--------------+-----------+------------+---------------
 Ain                                         |              230 |          78 |        66 |                  0 |            0 |        43 |        391 |           157
 Aisne                                       |              129 |          92 |        67 |                  0 |            0 |        51 |        797 |           165
 Allier                                      |              215 |          51 |        48 |                  0 |            0 |        32 |        317 |           126
 Alpes-de-Haute-Provence                     |               94 |          23 |        32 |                  0 |            0 |        15 |        198 |            59
 Alpes-Maritimes                             |              126 |         122 |       150 |                  0 |            0 |        79 |        163 |           428
 ArdÞche                                     |              218 |          47 |        65 |                  0 |            0 |        24 |        335 |            97
 Ardennes                                    |              100 |          49 |        31 |                  0 |            0 |        24 |        447 |           102
 AriÞge                                      |               76 |          23 |        32 |                  0 |            0 |        18 |        325 |            48
 Aube                                        |              144 |          43 |        44 |                  0 |           21 |        26 |        431 |            87
 Aude                                        |              251 |          44 |        56 |                  0 |           95 |        34 |        433 |           135
 Aveyron                                     |              187 |          47 |        68 |                  0 |           37 |        33 |        285 |           106
 Bas-Rhin                                    |              215 |         144 |       116 |                  0 |          101 |        86 |        514 |           273
 Bouches-du-Rh¶ne                            |              141 |         242 |       196 |                  0 |          304 |       173 |        119 |           733
 Calvados                                    |              131 |          88 |        89 |                  0 |           82 |        61 |        526 |           206
 Cantal                                      |              153 |          29 |        39 |                  0 |           21 |        17 |        250 |            65
 Charente                                    |               75 |          59 |        72 |                  0 |           52 |        30 |        359 |           121
 Charente-Maritime                           |              224 |          76 |       117 |                  0 |           98 |        44 |        462 |           216
 Cher                                        |              148 |          44 |        42 |                  0 |           38 |        27 |        286 |            99
 CorrÞze                                     |              117 |          36 |        44 |                  0 |           37 |        30 |        277 |            92
 Corse-du-Sud                                |               49 |          20 |        14 |                  0 |           33 |        12 |        124 |            60
 C¶te-d'Or                                   |              208 |          73 |        76 |                  0 |           66 |        38 |        698 |           162
 C¶tes-d'Armor                               |              259 |          90 |       117 |                  0 |          135 |        50 |        344 |           183
 Creuse                                      |               98 |          24 |        31 |                  0 |           34 |        11 |        255 |            56
 Deux-SÞvres                                 |              141 |          63 |        70 |                  0 |           54 |        29 |        252 |           119
 Dordogne                                    |              189 |          65 |        69 |                  0 |           62 |        32 |        503 |           138
 Doubs                                       |              193 |          74 |        43 |                  0 |           76 |        46 |        563 |           176
 Dr¶me                                       |              135 |          65 |        63 |                  0 |           77 |        39 |        362 |           150
 Essonne                                     |              160 |         156 |       102 |                  0 |           39 |        78 |        194 |           330
 Eure                                        |              116 |          82 |        44 |                  0 |           32 |        46 |        585 |           139
 Eure-et-Loir                                |              112 |          60 |        46 |                  0 |           28 |        36 |        363 |           103
 FinistÞre                                   |              255 |         130 |       132 |                  0 |          144 |        81 |        277 |           281
 Gard                                        |              256 |         102 |        89 |                  0 |           94 |        54 |        350 |           238
 Gers                                        |              116 |          36 |        36 |                  0 |           59 |        24 |        458 |            63
 Gironde                                     |              279 |         190 |       170 |                  0 |          181 |       114 |        534 |           512
 Guadeloupe                                  |               38 |          71 |        20 |                  0 |           37 |        47 |         32 |           145
 Guyane                                      |               20 |          60 |         5 |                  0 |           18 |        32 |         22 |            51
 Haut-Rhin                                   |              101 |          97 |        72 |                  0 |           74 |        59 |        366 |           187
 Haute-Corse                                 |               17 |          25 |        15 |                  0 |           36 |        13 |        236 |            69         
 Haute-Garonne                               |              206 |         160 |       131 |                  0 |          143 |       117 |        586 |           397         
 Haute-Loire                                 |              189 |          48 |        49 |                  0 |           41 |        27 |        257 |            78         
 Haute-Marne                                 |              137 |          29 |        26 |                  0 |           16 |        19 |        426 |            60         
 Haute-Sa¶ne                                 |              115 |          35 |        30 |                  0 |           33 |        21 |        536 |            82         
 Haute-Savoie                                |              209 |          99 |        66 |                  0 |           90 |        53 |        279 |           221         
 Haute-Vienne                                |              114 |          50 |        41 |                  0 |           65 |        35 |        195 |           149         
 Hautes-Alpes                                |               95 |          18 |        25 |                  0 |            0 |        12 |        162 |            54         
 Hautes-PyrÚnÚes                             |               81 |          36 |        38 |                  0 |           38 |        30 |        469 |            88         
 Hauts-de-Seine                              |               73 |         171 |       110 |                  0 |           67 |       101 |         36 |           452         
 HÚrault                                     |              276 |         141 |       148 |                  0 |          155 |       101 |        341 |           384         
 Ille-et-Vilaine                             |              313 |         135 |       145 |                  0 |          184 |        85 |        332 |           288         
 Indre                                       |               99 |          39 |        43 |                  0 |           49 |        22 |        241 |            80         
 Indre-et-Loire                              |              139 |          86 |        66 |                  0 |          109 |        46 |        272 |           191         
 IsÞre                                       |              331 |         150 |       107 |                  0 |          117 |        88 |        512 |           366         
 Jura                                        |               69 |          44 |        50 |                  0 |           43 |        33 |        492 |            87         
 La RÚunion                                  |               72 |         122 |        20 |                  0 |           41 |        82 |         24 |           245         
 Landes                                      |              131 |          58 |        58 |                  0 |           47 |        31 |        327 |           130         
 Loir-et-Cher                                |              131 |          49 |        50 |                  0 |           58 |        28 |        267 |            96         
 Loire                                       |              240 |          96 |       112 |                  0 |           62 |        78 |        320 |           217         
 Loire-Atlantique                            |              240 |         175 |       182 |                  0 |          125 |       122 |        207 |           389         
 Loiret                                      |              168 |          90 |        67 |                  0 |           74 |        53 |        325 |           177         
 Lot                                         |              131 |          27 |        38 |                  0 |           42 |        21 |        312 |            62         
 Lot-et-Garonne                              |              126 |          50 |        50 |                  0 |           38 |        26 |        319 |           116         
 LozÞre                                      |               70 |          20 |        28 |                  0 |           20 |        16 |        152 |            35         
 Maine-et-Loire                              |              270 |         115 |       123 |                  0 |           55 |        68 |        176 |           225         
 Manche                                      |              115 |          83 |        84 |                  0 |           49 |        41 |        445 |           134         
 Marne                                       |              117 |          79 |        47 |                  0 |           59 |        46 |        610 |           178         
 Martinique                                  |               31 |          77 |        25 |                  0 |           18 |        47 |         34 |           136         
 Mayenne                                     |              134 |          51 |        59 |                  0 |           47 |        29 |        240 |            82         
 Mayotte                                     |               14 |          34 |         0 |                  0 |            9 |        21 |         17 |            27         
 Meurthe-et-Moselle                          |              143 |          96 |        73 |                  0 |           64 |        57 |        591 |           251         
 Meuse                                       |               71 |          33 |        25 |                  0 |           22 |        18 |        499 |            56         
 Morbihan                                    |              243 |         109 |       120 |                  0 |          127 |        60 |        249 |           231         
 Moselle                                     |              172 |         129 |       117 |                  0 |           46 |        82 |        725 |           256         
 NiÞvre                                      |              105 |          45 |        36 |                  0 |           50 |        21 |        309 |            75         
 Nord                                        |              413 |         373 |       252 |                  0 |          142 |       184 |        647 |           875         
 Nouvelle-CalÚdonie                          |               23 |          67 |         0 |                  0 |            1 |        30 |         33 |             0         
 Oise                                        |              234 |         106 |        68 |                  0 |           45 |        56 |        680 |           213         
 Orne                                        |               69 |          52 |        54 |                  0 |           31 |        36 |        381 |            84         
 Paris                                       |               69 |         229 |        75 |                  0 |          297 |       232 |          1 |           874         
 Pas-de-Calais                               |              298 |         213 |       133 |                  0 |           72 |        88 |        887 |           486         
 PolynÚsie franþaise                         |                0 |          64 |         0 |                  0 |            1 |        21 |         48 |             0         
 Puy-de-D¶me                                 |              264 |          87 |        96 |                  0 |          104 |        55 |        463 |           227         
 PyrÚnÚes-Atlantiques                        |              164 |         106 |       110 |                  0 |           82 |        75 |        545 |           238         
 PyrÚnÚes-Orientales                         |              173 |          54 |        51 |                  0 |           95 |        35 |        226 |           169         
 Rh¶ne                                       |              255 |         230 |       157 |               9284 |          178 |       155 |        266 |           533         
 Saint-BarthÚlemy                            |                1 |           2 |         1 |                  0 |            3 |         2 |          1 |             3         
 Saint-Martin                                |                1 |           5 |         1 |                  0 |            0 |         6 |          1 |            11         
 Saint-Pierre-et-Miquelon                    |                1 |           3 |         1 |                  0 |            0 |         2 |          2 |             1         
 Sa¶ne-et-Loire                              |              223 |          76 |        93 |                  0 |          108 |        39 |        563 |           176         
 Sarthe                                      |              135 |          94 |        75 |                  0 |           57 |        50 |        352 |           151         
 Savoie                                      |              185 |          57 |        56 |                  0 |           69 |        28 |        273 |           144         
 Seine-et-Marne                              |              232 |         189 |       117 |                  0 |           47 |       105 |        507 |           348         
 Seine-Maritime                              |              260 |         170 |       109 |                  0 |           72 |       105 |        707 |           342         
 Seine-Saint-Denis                           |               79 |         209 |        63 |                  0 |           71 |       146 |         39 |           386         
 Somme                                       |              170 |          86 |        53 |                  0 |           43 |        54 |        771 |           186         
 Tarn                                        |               79 |          56 |        67 |                  0 |           56 |        40 |        314 |           125         
 Tarn-et-Garonne                             |               86 |          33 |        36 |                  0 |           34 |        25 |        195 |            72         
 Terres australes et antarctiques franþaises |                0 |           0 |         0 |                  0 |            0 |         0 |          5 |             0         
 Territoire de Belfort                       |               41 |          20 |         9 |                  0 |           17 |        13 |        101 |            47         
 Val-d'Oise                                  |              125 |         181 |        75 |                  0 |           42 |        91 |        183 |           319         
 Val-de-Marne                                |               77 |         164 |        72 |                  0 |           54 |       103 |         47 |           378         
 Var                                         |              137 |         115 |       129 |                  0 |          190 |        62 |        153 |           359         
 Vaucluse                                    |              121 |          69 |        59 |                  0 |          152 |        46 |        151 |           195         
 VendÚe                                      |              236 |          88 |       137 |                  0 |           48 |        58 |        253 |           209         
 Vienne                                      |              191 |          60 |        76 |                  0 |           79 |        35 |        265 |           138         
 Vosges                                      |              134 |          61 |        59 |                  0 |           32 |        39 |        506 |           126         
 Wallis et Futuna                            |                0 |           6 |         0 |                  0 |            0 |         2 |          3 |             0         
 Yonne                                       |              115 |          45 |        71 |                  0 |           49 |        19 |        423 |            97         
 Yvelines                                    |              197 |         188 |        90 |                  0 |           38 |       116 |        259 |           370         
(108 rows)                                                                                                                                                                     
                                                                                                                                                                               
                                                                                                                                                                               
                   region                    | population_totale                                                                                                               
---------------------------------------------+-------------------
 Terres australes et antarctiques franþaises |                  
 ╬le-de-France                               |          12463067
 Auvergne-Rh¶ne-Alpes                        |           8205557
 Nouvelle-Aquitaine                          |           6150451
 Occitanie                                   |           6124653
 Hauts-de-France                             |           5992194
 Grand Est                                   |           5563378
 Provence-Alpes-C¶te d'Azur                  |           5218960
 Pays de la Loire                            |           3907156
 Bretagne                                    |           3449370
 Normandie                                   |           3345842
 Bourgogne-Franche-ComtÚ                     |           2802670
 Centre-Val de Loire                         |           2587031
 La RÚunion                                  |            889679
 Guadeloupe                                  |            384160
 Martinique                                  |            360630
 Corse                                       |            355486
 Guyane                                      |            293996
 PolynÚsie franþaise                         |            278786
 Nouvelle-CalÚdonie                          |            264596
 Mayotte                                     |            256518
 Saint-Martin                                |             31160
 Wallis et Futuna                            |             11151
 Saint-BarthÚlemy                            |             10660
 Saint-Pierre-et-Miquelon                    |              5790
(25 rows)

       departement        | nb_lycees                                                                                                                                          
--------------------------+-----------
 Paris                    |       232
 Nord                     |       184
 Bouches-du-Rh¶ne         |       173
 Rh¶ne                    |       155
 Seine-Saint-Denis        |       146
 Loire-Atlantique         |       122
 Haute-Garonne            |       117
 Yvelines                 |       116
 Gironde                  |       114
 Seine-et-Marne           |       105
 Seine-Maritime           |       105
 Val-de-Marne             |       103
 Hauts-de-Seine           |       101
 HÚrault                  |       101
 Val-d'Oise               |        91
 Pas-de-Calais            |        88
 IsÞre                    |        88
 Bas-Rhin                 |        86
 Ille-et-Vilaine          |        85
 Moselle                  |        82
 La RÚunion               |        82
 FinistÞre                |        81
 Alpes-Maritimes          |        79
 Loire                    |        78
 Essonne                  |        78
 PyrÚnÚes-Atlantiques     |        75
 Maine-et-Loire           |        68
 Var                      |        62
 Calvados                 |        61
 Morbihan                 |        60
 Haut-Rhin                |        59
 VendÚe                   |        58
 Meurthe-et-Moselle       |        57
 Oise                     |        56
 Puy-de-D¶me              |        55
 Somme                    |        54
 Gard                     |        54
 Haute-Savoie             |        53                                                                                                                                          
 Loiret                   |        53                                                                                                                                          
 Aisne                    |        51                                                                                                                                          
 Sarthe                   |        50                                                                                                                                          
 C¶tes-d'Armor            |        50                                                                                                                                          
 Guadeloupe               |        47                                                                                                                                          
 Martinique               |        47                                                                                                                                          
 Marne                    |        46                                                                                                                                          
 Vaucluse                 |        46                                                                                                                                          
 Indre-et-Loire           |        46                                                                                                                                          
 Doubs                    |        46                                                                                                                                          
 Eure                     |        46                                                                                                                                          
 Charente-Maritime        |        44                                                                                                                                          
 Ain                      |        43                                                                                                                                          
 Manche                   |        41                                                                                                                                          
 Tarn                     |        40                                                                                                                                          
 Vosges                   |        39                                                                                                                                          
 Dr¶me                    |        39                                                                                                                                          
 Sa¶ne-et-Loire           |        39                                                                                                                                          
 C¶te-d'Or                |        38                                                                                                                                          
 Orne                     |        36                                                                                                                                          
 Eure-et-Loir             |        36                                                                                                                                          
 Vienne                   |        35                                                                                                                                          
 PyrÚnÚes-Orientales      |        35                                                                                                                                          
 Haute-Vienne             |        35                                                                                                                                          
 Aude                     |        34                                                                                                                                          
 Aveyron                  |        33                                                                                                                                          
 Jura                     |        33                                                                                                                                          
 Dordogne                 |        32                                                                                                                                          
 Allier                   |        32                                                                                                                                          
 Guyane                   |        32                                                                                                                                          
 Landes                   |        31                                                                                                                                          
 Nouvelle-CalÚdonie       |        30                                                                                                                                          
 Charente                 |        30                                                                                                                                          
 Hautes-PyrÚnÚes          |        30                                                                                                                                          
 CorrÞze                  |        30                                                                                                                                          
 Mayenne                  |        29                                                                                                                                          
 Deux-SÞvres              |        29                                                                                                                                          
 Loir-et-Cher             |        28                                                                                                                                          
 Savoie                   |        28                                                                                                                                          
 Haute-Loire              |        27                                                                                                                                          
 Cher                     |        27                                                                                                                                          
 Aube                     |        26                                                                                                                                          
 Lot-et-Garonne           |        26                                                                                                                                          
 Tarn-et-Garonne          |        25                                                                                                                                          
 Gers                     |        24                                                                                                                                          
 ArdÞche                  |        24                                                                                                                                          
 Ardennes                 |        24                                                                                                                                          
 Indre                    |        22                                                                                                                                          
 Mayotte                  |        21                                                                                                                                          
 PolynÚsie franþaise      |        21                                                                                                                                          
 NiÞvre                   |        21                                                                                                                                          
 Haute-Sa¶ne              |        21                                                                                                                                          
 Lot                      |        21                                                                                                                                          
 Haute-Marne              |        19                                                                                                                                          
 Yonne                    |        19                                                                                                                                          
 AriÞge                   |        18                                                                                                                                          
 Meuse                    |        18                                                                                                                                          
 Cantal                   |        17                                                                                                                                          
 LozÞre                   |        16                                                                                                                                          
 Alpes-de-Haute-Provence  |        15                                                                                                                                          
 Haute-Corse              |        13                                                                                                                                          
 Territoire de Belfort    |        13                                                                                                                                          
 Hautes-Alpes             |        12                                                                                                                                          
 Corse-du-Sud             |        12                                                                                                                                          
 Creuse                   |        11                                                                                                                                          
 Saint-Martin             |         6                                                                                                                                          
 Saint-BarthÚlemy         |         2                                                                                                                                          
 Wallis et Futuna         |         2                                                                                                                                          
 Saint-Pierre-et-Miquelon |         2                                                                                                                                          
(107 rows)                                                                                                                                                                     
                                                                                                                                                                               
                                                                                                                                                                               
       departement        | moyenne_pharmacies_par_commune                                                                                                                     
--------------------------+--------------------------------
 Paris                    |           874.0000000000000000
 Hauts-de-Seine           |            12.9142857142857143
 Saint-Martin             |            11.0000000000000000
 La RÚunion               |            10.2083333333333333
 Seine-Saint-Denis        |             9.8974358974358974
 Val-de-Marne             |             8.2173913043478261
 Bouches-du-Rh¶ne         |             7.2574257425742574
 Alpes-Maritimes          |             6.3880597014925373
 Guadeloupe               |             4.8333333333333333
 Martinique               |             4.6896551724137931
 Guyane                   |             4.2500000000000000
 Rh¶ne                    |             4.0687022900763359
 Val-d'Oise               |             3.7976190476190476
 Var                      |             3.7395833333333333
 Yvelines                 |             3.3333333333333333
 Essonne                  |             3.2038834951456311
 Haute-Garonne            |             3.1259842519685039
 Saint-BarthÚlemy         |             3.0000000000000000
 HÚrault                  |             2.8656716417910448
 Nord                     |             2.7777777777777778
 Gironde                  |             2.7379679144385027
 Vaucluse                 |             2.6712328767123288
 PyrÚnÚes-Atlantiques     |             2.5869565217391304
 Maine-et-Loire           |             2.5862068965517241
 Marne                    |             2.5797101449275362
 Seine-Maritime           |             2.5714285714285714
 C¶te-d'Or                |             2.5714285714285714
 Loire                    |             2.5232558139534884
 Loire-Atlantique         |             2.4935897435897436
 Meurthe-et-Moselle       |             2.3904761904761905
 Pas-de-Calais            |             2.2604651162790698
 Haute-Savoie             |             2.2323232323232323
 Corse-du-Sud             |             2.2222222222222222
 Ille-et-Vilaine          |             2.2153846153846154
 Indre-et-Loire           |             2.1954022988505747
 IsÞre                    |             2.1785714285714286
 Gard                     |             2.1636363636363636
 Seine-et-Marne           |             2.1614906832298137                                                                                                                     
 Haute-Corse              |             2.1562500000000000                                                                                                                     
 Hautes-PyrÚnÚes          |             2.1463414634146341                                                                                                                     
 PyrÚnÚes-Orientales      |             2.1392405063291139                                                                                                                     
 Haute-Vienne             |             2.1285714285714286                                                                                                                     
 Bas-Rhin                 |             2.0839694656488550                                                                                                                     
 Dr¶me                    |             2.0833333333333333                                                                                                                     
 Puy-de-D¶me              |             2.0636363636363636                                                                                                                     
 Territoire de Belfort    |             2.0434782608695652                                                                                                                     
 Moselle                  |             2.0317460317460317                                                                                                                     
 Loiret                   |             2.0113636363636364                                                                                                                     
 FinistÞre                |             1.9929078014184397                                                                                                                     
 Haut-Rhin                |             1.9893617021276596                                                                                                                     
 Allier                   |             1.9687500000000000                                                                                                                     
 Calvados                 |             1.9619047619047619                                                                                                                     
 Mayotte                  |             1.9285714285714286                                                                                                                     
 Somme                    |             1.8979591836734694                                                                                                                     
 Doubs                    |             1.8924731182795699                                                                                                                     
 Sa¶ne-et-Loire           |             1.8723404255319149                                                                                                                     
 Cher                     |             1.8679245283018868                                                                                                                     
 Vienne                   |             1.8400000000000000                                                                                                                     
 Savoie                   |             1.8227848101265823                                                                                                                     
 Haute-Marne              |             1.8181818181818182                                                                                                                     
 Aube                     |             1.8125000000000000                                                                                                                     
 Landes                   |             1.8055555555555556                                                                                                                     
 Deux-SÞvres              |             1.8030303030303030                                                                                                                     
 VendÚe                   |             1.8017241379310345                                                                                                                     
 Morbihan                 |             1.7906976744186047                                                                                                                     
 Charente-Maritime        |             1.7851239669421488                                                                                                                     
 Sarthe                   |             1.7764705882352941                                                                                                                     
 Tarn                     |             1.7605633802816901                                                                                                                     
 Aisne                    |             1.7553191489361702                                                                                                                     
 Aude                     |             1.7532467532467532                                                                                                                     
 Oise                     |             1.7459016393442623                                                                                                                     
 NiÞvre                   |             1.7441860465116279                                                                                                                     
 Hautes-Alpes             |             1.7419354838709677                                                                                                                     
 Manche                   |             1.7179487179487179                                                                                                                     
 Eure-et-Loir             |             1.6885245901639344                                                                                                                     
 Vosges                   |             1.6800000000000000                                                                                                                     
 Mayenne                  |             1.6734693877551020                                                                                                                     
 CorrÞze                  |             1.6727272727272727                                                                                                                     
 Ardennes                 |             1.6451612903225806                                                                                                                     
 Lot-et-Garonne           |             1.6338028169014085                                                                                                                     
 Indre                    |             1.6326530612244898                                                                                                                     
 Aveyron                  |             1.6307692307692308                                                                                                                     
 C¶tes-d'Armor            |             1.6194690265486726                                                                                                                     
 Eure                     |             1.6162790697674419                                                                                                                     
 Alpes-de-Haute-Provence  |             1.5945945945945946                                                                                                                     
 Charente                 |             1.5921052631578947                                                                                                                     
 Ain                      |             1.5858585858585859                                                                                                                     
 Tarn-et-Garonne          |             1.5652173913043478                                                                                                                     
 Meuse                    |             1.5555555555555556                                                                                                                     
 Lot                      |             1.5500000000000000                                                                                                                     
 Cantal                   |             1.5476190476190476                                                                                                                     
 Gers                     |             1.5365853658536585                                                                                                                     
 Loir-et-Cher             |             1.5000000000000000                                                                                                                     
 Yonne                    |             1.4923076923076923                                                                                                                     
 Jura                     |             1.4745762711864407                                                                                                                     
 Orne                     |             1.4736842105263158                                                                                                                     
 Dordogne                 |             1.4680851063829787                                                                                                                     
 AriÞge                   |             1.4545454545454545                                                                                                                     
 ArdÞche                  |             1.4477611940298507                                                                                                                     
 LozÞre                   |             1.4000000000000000                                                                                                                     
 Haute-Sa¶ne              |             1.3666666666666667                                                                                                                     
 Haute-Loire              |             1.3448275862068966                                                                                                                     
 Creuse                   |             1.3023255813953488                                                                                                                     
 Saint-Pierre-et-Miquelon |         1.00000000000000000000                                                                                                                     
(104 rows)                                                                                                                                                                     
                                                                                                                                                                               

      