# LIBRARY IMPORTS *
from datetime import datetime
import requests
from bs4 import BeautifulSoup
import re
from robobrowser import RoboBrowser
import json
import sys
import os


def mapper(f,lst):
    return list( map(lambda x:f(x),lst) )

def filterer(f,lst):
    return list( filter(lambda x:f(x),lst) )
    
currentDirectory = os.getcwd() + '/app/python/deadlines'

'========================================================================================================================================'
url = 'https://coursemology.org/users/sign_in'
email = 'e0425978@u.nus.edu'
password = 'slpypnda'

s_arg = sys.argv


def scrape_cs1010s(url,email,password ):
    browser = RoboBrowser(parser='html.parser')
    browser.open(url)
    search = browser.get_form()
    search[ 'user[email]' ] = str(email)
    search[ 'user[password]' ] = str(password)
    browser.submit_form(search,submit=search.submit_fields['commit'])

    # main page
    browser.follow_link(browser.find_all('a')[2])
    
    # missions
    browser.follow_link(browser.find_all('a')[17])

    # find names
    reduced = filterer( lambda x: len(list(x.children))>=1 , browser.find_all('th')   ) 
    reduced= filterer( lambda x: 'colspan'in x.attrs, reduced)
    # unsure of object structure so convert to list type and assess last element
    names =  mapper(lambda x: list(list(x.children)[-1])[-1], reduced)

    # find deadlines
    deadlines_tags = list(filter( lambda x:x['class']==['table-end-at'], browser.find_all('td')   ) )
    deadlines = list( map (lambda x: (list(x))[0] if list(x) else 'not yet', deadlines_tags ))
    curr_yr = datetime.now().year

    #returns a list of datetime objects
    dates = mapper( lambda x:  str( datetime.strptime( f"{curr_yr} {x}",  '%Y %d %b %H:%M') ) if x!='not yet' else 'Not yet', deadlines)

    array = []
    for n,d in zip(names,dates):
        dic1 = {}
        dic1['title']= n
        dic1['datetime']= d 
        array.append(dic1)
        
    dic={}
    dic['data']=array

   #scrape exam details
    with open(currentDirectory + '/data.json', 'w') as json_file:
      json.dump(dic, json_file) 


def scrape_cs2040s(url,email,password ):
    browser = RoboBrowser(parser='html.parser')
    browser.open(url)
    search = browser.get_form()
    search[ 'user[email]' ] = str(email)
    search[ 'user[password]' ] = str(password)
    browser.submit_form(search,submit=search.submit_fields['commit'])

    # main page
    browser.follow_link(browser.find_all('a')[2])
    
    # missions
    browser.follow_link(browser.find_all('a')[11])

    # find names
    reduced = filterer( lambda x: len(list(x.children))>=1 , browser.find_all('th')   ) 
    reduced= filterer( lambda x: 'colspan'in x.attrs, reduced)
    # unsure of object structure so convert to list type and assess last element
    names =  mapper(lambda x: list(list(x.children)[-1])[-1], reduced)

    # find deadlines
    deadlines_tags = list(filter( lambda x:x['class']==['table-end-at'], browser.find_all('td')   ) )
    deadlines = list( map (lambda x: (list(x))[0] if list(x) else 'not yet', deadlines_tags ))
    curr_yr = datetime.now().year

    #returns a list of datetime objects
    dates = mapper( lambda x:  str( datetime.strptime( f"{curr_yr} {x}",  '%Y %d %b %H:%M') ) if x!='not yet' else 'Not yet', deadlines)

    array = []
    for n,d in zip(names,dates):
        dic1 = {}
        dic1['title']= n
        dic1['datetime']= d 
        array.append(dic1)
        
    dic={}
    dic['data']=array

   #scrape exam details
    with open(currentDirectory + '/data.json', 'w') as json_file:
      json.dump(dic, json_file)





def scrapper(url,email,password ,name ):
    if '1010' in str(name) :
        return scrape_cs1010s(url,email,password)
    else:
        return scrape_cs2040s(url,email,password)




scrapper(s_arg[1],s_arg[2],s_arg[3],s_arg[4])
    
