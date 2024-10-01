import pandas as pd
from sqlalchemy import create_engine

conn_string = 'postgresql+psycopg2://postgres:Njoka123#@localhost:5433/painting'

db = create_engine(conn_string)
conn = db.connect()

files = ['artist','canvas_size','image_link','museum','museum_hours','product_size','subject','work']

for file in files:
    df = pd.read_csv(f'C:/Users/Administrator/Desktop/Main/sql_case_study/archive (4)/{file}.csv')
    df.to_sql(file,con=conn,if_exists='replace', index= False)