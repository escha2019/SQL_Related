#!/usr/bin/env python
# coding: utf-8

# Note: I do not have a personal computer currently. I used my school’s computer. And, using my school computer meant that I could not download a software 
# (e.g. mysql workbench), but I could pip install a python library. So, I connected to the database using connector/Python 
# (here’s the library url: https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html)

# In[1]:


import mysql.connector
import pandas as pd

# create connection
cnx = mysql.connector.connect(user='user_name', password='password_here',
                              host='ip_here', 
                              database='db_name')
conn = cnx.cursor()


# In[2]:


# See all 13 tables
info = """SELECT table_name FROM information_schema.tables;
       """
conn.execute(info, conn)

conn.fetchall()[-13:]


# In[4]:


# 1. when was Grace Mayo born?
one = """SELECT birth_date 
         FROM person
         WHERE LOWER(first_name) = '{0}'
            AND LOWER(last_name) = '{1}';
       """.format('grace', 'mayo')

conn.execute(one, conn)

conn.fetchall()[0][0] # January 1, 1978


# In[5]:


# 2. What was Grace mayo position_id in June 2018
two = """SELECT position_id.position_id
         FROM person INNER JOIN position_person ON person.person_id=position_person.person_id 
                 INNER JOIN position_id ON position_id.position_id_pk=position_person.position_id_pk
         WHERE LOWER(person.first_name) = '{0}'
            AND LOWER(person.last_name) = '{1}'
            # keep position_ids that started atleast in june 2018
            AND position_id.begin_date < '{2}'
            # remove position_ids that ended b4 june 2018, 
            # excluding end_dates that are null or current position_ids
            AND (position_id.end_date >= '{3}' OR position_id.end_date IS NULL);
     """.format('grace', 'mayo', '2018-07-01', '2018-06-01')      

conn.execute(two, conn)

columns = conn.description 
result = [{columns[index][0]:column for index, column in enumerate(value)} for value in conn.fetchall()]

pd.DataFrame(result) # output as a dataframe


# In[6]:


# 3. What's the title of Grace mayo job's title
thr = """SELECT CONCAT(job.description, ' (', job.title , ')')
         FROM person INNER JOIN position_person ON person.person_id=position_person.person_id
               INNER JOIN position ON position.position_id_pk=position_person.position_id_pk
               INNER JOIN job ON job.job_id=position.job_id
         WHERE LOWER(person.first_name) = '{0}'
            AND LOWER(person.last_name) = '{1}';
       """.format('grace', 'mayo')

conn.execute(thr, conn)
conn.fetchall()[0][0]


# In[7]:


# 4. In what county does Grace Mayo work?
fou = """SELECT county.county
         FROM person INNER JOIN position_person ON person.person_id=position_person.person_id
              INNER JOIN position_community ON position_community.position_id_pk=position_person.position_id_pk
              INNER JOIN community ON community.community_id=position_community.community_id
              INNER JOIN district ON district.district_id=community.district_id
              INNER JOIN health_district ON health_district.health_district_id=district.health_district_id
              INNER JOIN county ON county.county_id = health_district.county_id
         WHERE LOWER(person.first_name) = '{0}'
            AND LOWER(person.last_name) = '{1}';
       """.format('grace', 'mayo')

conn.execute(fou, conn)

columns = conn.description 
result = [{columns[index][0]:column for index, column in enumerate(value)} for value in conn.fetchall()]

pd.DataFrame(result) # output as a dataframe


# In[30]:


# 5. Which community does Grace Mayo serve in?
fiv = """SELECT community.community
         FROM person INNER JOIN position_person ON person.person_id=position_person.person_id
              INNER JOIN position_community ON position_community.position_id_pk=position_person.position_id_pk
              INNER JOIN community ON community.community_id=position_community.community_id
         WHERE LOWER(person.first_name) = '{0}'
            AND LOWER(person.last_name) = '{1}';
       """.format('grace', 'mayo')

conn.execute(fiv, conn)

columns = conn.description 
result = [{columns[index][0]:column for index, column in enumerate(value)} for value in conn.fetchall()]

pd.DataFrame(result) # output as a dataframe


# In[8]:


# 6. Who was Grace Mayo Supervisor in june 2018 and what was her supervisor's position_id?

sql = """SELECT per.first_name,
                per.last_name,
                p.position_id
         FROM (SELECT position_supervisor.position_supervisor_id_pk
               FROM person INNER JOIN position_person ON person.person_id=position_person.person_id 
                       INNER JOIN position_id ON position_id.position_id_pk=position_person.position_id_pk
                       INNER JOIN position_supervisor ON position_supervisor.position_id_pk=position_person.position_id_pk
               WHERE LOWER(person.first_name) = '{0}'
                  AND LOWER(person.last_name) = '{1}'
                  AND position_id.position_id = '{2}' # taken from Q2
                  # keep position_ids that started atleast in june 2018
                  AND position_supervisor.begin_date < '{3}'
                  # remove position_ids that ended b4 june 2018, 
                  # excluding end_dates that are null or current position_ids
                  AND (position_supervisor.end_date >= '{4}' OR position_supervisor.end_date IS NULL)
               ) AS sup_position_id INNER JOIN position_id AS p ON p.position_id_pk=sup_position_id.position_supervisor_id_pk
               INNER JOIN position_person AS pp ON p.position_id_pk=pp.position_id_pk 
               INNER JOIN person AS per ON per.person_id=pp.person_id
    """.format('grace', 'mayo', 'DR27-06', '2018-07-01', '2018-06-01' )

conn.execute(sql)
columns = conn.description 
result = [{columns[index][0]:column for index, column in enumerate(value)} for value in conn.fetchall()]

pd.DataFrame(result) # output as a dataframe


# In[9]:


# 7. How many positions did Grace Mayo's supervisor supervised in June 2018?
sql = """SELECT COUNT(DISTINCT p.position_id) AS count_of_supervised
         FROM position_supervisor AS supervisee INNER JOIN position_id AS p ON \
                        p.position_id_pk=supervisee.position_id_pk
         WHERE supervisee.position_supervisor_id_pk = 
                (SELECT position_supervisor.position_supervisor_id_pk
                  FROM person INNER JOIN position_person ON person.person_id=position_person.person_id 
                          INNER JOIN position_id ON position_id.position_id_pk=position_person.position_id_pk
                          INNER JOIN position_supervisor ON position_supervisor.position_id_pk=position_person.position_id_pk
                  WHERE person.person_id = '{0}' # Grace Mayo id
                     AND position_id.position_id = '{1}' # Grace Mayo postion_id in June, from Q2
                     # keep position_ids that started atleast in july 2018
                     AND position_supervisor.begin_date < '{2}'
                     # remove position_ids that ended b4 june 2018, 
                     # excluding end_dates that are null or current position_ids
                     AND (position_supervisor.end_date >= '{3}' OR position_supervisor.end_date IS NULL)
                ) 
               # keep position_ids that started atleast in june 2018
               AND p.begin_date < '{4}'
               # remove position_ids that ended b4 june 2018, 
               # excluding end_dates that are null or current position_ids
               AND (p.end_date >= '{5}' OR p.end_date IS NULL)
    """.format('2320', 'DR27-06', '2018-07-01', '2018-06-01', '2018-07-01', '2018-06-01')
conn.execute(sql)
columns = conn.description 
result = [{columns[index][0]:column for index, column in enumerate(value)} for value in conn.fetchall()]

pd.DataFrame(result) # output as a dataframe


# In[33]:


# close connection to db
conn.close()

