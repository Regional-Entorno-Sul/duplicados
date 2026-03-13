# duplicados
A principal finalidade desse utilitário é identificar notificações na base de dados unificados registradas no SIVEP Gripe que são de outra UF e, portanto, não são acessíveis para consulta nesses sistema.  
Isso é feito usando como fonte o arquivo fornecido pela SESGO, "dados_unificados_duplicados". Este é um arquivo no formato CSV que informa para o usuário que há registros com duplicidade em dois sistemas diferentes, o SIVEP Gripe e o e-SUS VE Notifica. Entretanto, para o usuário que deve acessar o SIVEP Gripe e cancelar a notificação com esse problema, pode não conseguir fazê-lo, pelo fato de que a notificação pode ter sido notificada em outra UF e, portanto, pelas regras vigentes desse sistema, não fica visível para o usuário esta notificação, tornando impossível para este, conseguir excluir no SIVEP Gripe a notificação duplicada. O utilitário torna então visível para o usuário essas notificações inacessíveis, evitando que este tenha o trabalho de tentar acessá-la uma a uma no SIVEP Gripe, o que faria que este perdesse tempo em tentar, inutilmente, excluir uma notificação com essa característica.   
Além disso, para facilitar o trabalho do operador que tem que lidar com o problema da duplicidade, o utilitário ainda faz a separação das duplicidades de registros da mesma regional mas de municípios diferentes, registros da mesma regional mas de municípios iguais, registros que talvez não sejam duplicidades, e outros recursos.  

Sintaxe do programa:  
~~~
duplicados.exe [sigla da UF] [modo]  
[modo] --unificados: processa o arquivo 'dados_unificados_duplicados'
[modo] --srag: processa o arquivo 'dados_srag_duplicados'
Exemplo: duplicados.exe GO  --srag
~~~

