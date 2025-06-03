import psycopg2

conn = None # Inicializa a conexão como None

try:
    # conecta ao banco de dados
    conn = psycopg2.connect(
        dbname="stars_db",
        user="postgres",
        password="postgres", # A senha que você definiu
        host="localhost",
        port="5432"
    )
    print("Conectado ao BD!")
    cursor = conn.cursor()

    # garante ordem padrao inicio-fim por conta dos ids incrementais
    print("\n--- Lendo entradas do Log ---")
    log_entries = []
    cursor.execute("SELECT transaction_id, operation, changed_star_name, new_tempK, new_radS FROM stars_log ORDER BY log_id ASC;")
    log_entries = cursor.fetchall()
    print(f"Lidas {len(log_entries)} entradas do log.")

    
    # encontra transacoes que deram begin e commit 
    committed_transactions = []
    for entry in log_entries:
        trans_id = entry[0]
        operation = entry[1]
        if operation == 'COMMIT':
            committed_transactions.append(trans_id)
            print(f"{trans_id} comittou.")

    # aplica o redo nas operacoes do log
    for entry in log_entries:
        trans_id = entry[0]
        operation_type = entry[1]
        star_name = entry[2] # changed_star_name do log
        tempK = entry[3]     # new_tempK do log
        radS = entry[4]      # new_radS do log

        # apenas aplica redo caso tenha commitado e seja um write (insert, update, delete)
        if trans_id in committed_transactions: #poderia ter DELETE mas nao usei no codigo
            if operation_type == 'INSERT':
                sql = "INSERT INTO stars (star_name, tempK, radS) VALUES (%s, %s, %s) ON CONFLICT (star_name) DO NOTHING;"
                cursor.execute(sql, (star_name, tempK, radS))
                print(f"REDO: Aplicado INSERT da transacao {trans_id} para estrela '{star_name}' (tempK={tempK}, radS={radS})")

            elif operation_type == 'UPDATE':
                sql = "UPDATE stars SET tempK = %s, radS = %s WHERE star_name = %s;"
                cursor.execute(sql, (tempK, radS, star_name))
                print(f"REDO: Aplicado UPDATE da transacao {trans_id} para estrela '{star_name}' (tempK={tempK}, radS={radS})")
        

    conn.commit() # salva as alteracoes do redo
    cursor.close()
    print("\n--- REDO concluído com sucesso! As alterações comitadas foram restauradas. ---")

except psycopg2.Error as error: # captura erros
    print(f"Erro : {error}")
finally:
    if conn is not None:
        conn.close()
    print("Desconectando do BD.")