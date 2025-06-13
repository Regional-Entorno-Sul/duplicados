Function main()

set color to bg+/
cls

@ 1,0 say chr(201) + chr(205)
for i := 1 to 70
@ 1,i say chr(205)
next
@ 1,71 say chr(187)
for i := 1 to 70
@ 10,i say chr(205)
next
@ 10,71 say chr(188)

@ 2,0 say chr(186) + " Duplicados.exe - versao 1.0 - 10/06/2025                          " + "   " + chr(186)
@ 3,0 say chr(186) + " Regional entorno sul - Macroregional Nordeste                     " + "   " + chr(186)
@ 4,0 say chr(186) + " Identifica notificacoes na base de dados unificados registradas   " + "   " + chr(186)
@ 5,0 say chr(186) + " no SIVEP Gripe que sao de outra UF e portanto nao acessiveis para " + "   " + chr(186)
@ 6,0 say chr(186) + " consulta neste sistema.                                           " + "   " + chr(186)
@ 7,0 say chr(186) + " Sintaxe do programa:                                              " + "   " + chr(186)
@ 8,0 say chr(186) + " duplicados.exe [sigla da UF]                                      " + "   " + chr(186)
@ 9,0 say chr(186) + " Exemplo: duplicados.exe GO                                        " + "   " + chr(186)

@ 10,0 say chr(200) + chr(205)

set color to g+/

cUF := upper( HB_ArgV ( 1 ) )

if empty( cUF ) = .T.
set color to r+/
? "Falta o argumento da UF na linha de comando..."
? "Fim do programa."
quit
endif

@ 11,0 say "Excluindo arquivos usados (se existirem)..."
if file("c:\duplicados\base_srag\srag_base_zero.dbf") = .T.
delete file "c:\duplicados\base_srag\srag_base_zero.dbf"
endif

@ 12,0 say "Copiando arquivo para a fusao das bases de dados..."
cOrigem := "c:\duplicados\model\srag_base_zero.dbf"
cDestino := "c:\duplicados\base_srag\srag_base_zero.dbf"
copy file ( cOrigem ) to ( cDestino )

@ 13,0 say "Fusao dos arquivos de diferentes anos em um so arquivo..."
use "c:\duplicados\base_srag\srag_base_zero.dbf"
append from "c:\duplicados\base_srag\srag_2020.dbf"
append from "c:\duplicados\base_srag\srag_2021.dbf"
append from "c:\duplicados\base_srag\srag_2022.dbf"
append from "c:\duplicados\base_srag\srag_2023.dbf"
append from "c:\duplicados\base_srag\srag_2024.dbf"
append from "c:\duplicados\base_srag\srag_2025.dbf"

@ 14,0 say "Deixando na base de dados apenas registros da UF de interesse..."
use "c:\duplicados\base_srag\srag_base_zero.dbf"
delete for sg_uf_not = ( cUF )
pack
close

@ 15,0 say "Criando array com os registros de outra UF..."
	  public aArray_registros := {}
	  use "c:\duplicados\base_srag\srag_base_zero.dbf"
      nRecs := reccount()
      FOR x := 1 TO nRecs
	  AAdd( aArray_registros, {alltrim(nu_notific)} )
	  skip
	  NEXT
	  close

@ 16,0 say "Procurando no arquivo de dados unificados, registros notificados em outra UF..."
@ 17,0 say "Andamento:"
use "c:\duplicados\base_unificados\uni_data.dbf"
nRecs2 := reccount()

for n := 1 to nRecs2

nPercent := (n * 100) / nRecs2
set color to w+/
@ 17,10 say alltrim( str( nPercent ) ) + "%"

for z := 1 to nRecs
cReg := aArray_registros[z,1]

if alltrim( fonte ) = "SIVEP"
if ( alltrim( str( numero_not ) ) = alltrim( cReg ) )
replace duplicada with "x"
endif
endif

if alltrim( fonte_post ) = "SIVEP"
if ( alltrim( str( numero_no2 ) ) = alltrim( cReg ) )
replace duplicada with "x"
endif
endif

next

skip
next
close

set color to g+/

@ 18,0 say "Exportando municipios do arquivo txt para arquivo dbf..."
use "c:\duplicados\munics\munics.dbf"
zap
append from "c:\duplicados\munics\munics.txt" delimited
close

@ 19,0 say "Criando array com os nomes dos municipios..."
	  public aArray_municipios := {}
	  use "c:\duplicados\munics\munics.dbf"
      nRecs3 := reccount()
      FOR x := 1 TO nRecs3
	  AAdd( aArray_municipios, {alltrim( munic )} )
	  skip
	  NEXT
	  close

@ 20,0 say "Procurando no arquivo de dados unificados, registros notificados de outros municipios."
@ 21,0 say "Andamento:"
use "c:\duplicados\base_unificados\uni_data.dbf"
nRecs4 := reccount()

for n := 1 to nRecs4

nPercent := (n * 100) / nRecs4
set color to w+/
@ 21,10 say alltrim( str( nPercent ) ) + "%"

for z := 1 to nRecs3
cReg := aArray_municipios[z,1]

if ( alltrim( municipio ) ) = alltrim( cReg )
replace motivo with "x"
endif

if ( alltrim( municipio_ ) ) = alltrim( cReg )
replace tipo_test2 with "x"
endif

next

skip
next
close

use "c:\duplicados\base_unificados\uni_data.dbf"

do while .not. eof()
replace tipo_teste with "x" for motivo = "x" .and. tipo_test2 = "x"

skip
enddo
close

use "c:\duplicados\base_unificados\uni_data.dbf"

do while .not. eof()
replace resultado2 with "x" for tipo_teste = "x" .and. duplicada = "x"

skip
enddo
close

* ------------------------------------------------------------------------------------------------------------------------------------
* |      Campo       | Marcacao |                          Descricao                                                                 |
* ------------------------------------------------------------------------------------------------------------------------------------
* | Duplicada         | x        | Marca as notificacoes do SIVEP Gripe de outra UF.                                                 |
* ------------------------------------------------------------------------------------------------------------------------------------
* | Resultado2        | x        | Marca as notificacoes de municipios da mesma regional e notificacoes do SIVEP Gripe de outra UF.  |
* ------------------------------------------------------------------------------------------------------------------------------------
* | Motivo            | x        | Marca municipios da mesma regional campo lado esquerdo.                                           |
* ------------------------------------------------------------------------------------------------------------------------------------
* | Tipo_test2        | x        | Marca municipios da mesma regional campo lado direito.                                            |
* ------------------------------------------------------------------------------------------------------------------------------------
* | Tipo_teste        | x        | Marca municipios da mesma regional.                                                               |
* ------------------------------------------------------------------------------------------------------------------------------------

set color to gr+/

use "c:\duplicados\base_unificados\uni_data.dbf"
@ 22,0 say "=============================="
@ 23,0 say "Resultado do processamento:"
nTotal_uni := reccount()
count to nUF for duplicada = "True"
count to nOutraUF for duplicada = "x"
count to nMunicReg for resultado2 = "x"
count to nMunicRegNao for resultado2 <> "x"
count to nRegiTrab for ( duplicada = "True" .and. resultado2 = "x" )
@ 24,0 say "Total de registros:" + alltrim(str( nTotal_uni ) )
@ 25,0 say "Registros do SIVEP Gripe notificados em outra UF:" + alltrim(str( nOutraUF ) )
@ 26,0 say "Registros do SIVEP Gripe notificados em " + cUF + ":" + alltrim(str( nUF ) )
@ 27,0 say "Registros de municipios da mesma regional:" + alltrim(str( nMunicReg ) )
@ 28,0 say "Registros de municipios de regionais diferentes:" + alltrim(str( nMunicRegNao ) )
@ 29,0 say "Registros que podem ser trabalhados:" + alltrim(str( nRegiTrab ) )



return nil
