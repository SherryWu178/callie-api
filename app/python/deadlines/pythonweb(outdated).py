'''Callie's brain
 check weekly commitments for each mods and show total time spent
 prompt warning if time spent below recommended 
 object to store time data
 inheritance to reuse functions, calender to acess all subclass attributes

Phase 2:
how to stall all module info
 store all datetime objects for each start:end in event object for each event


 methods to modify and update calender info
    -> non acad -> events objects
        store all datetimes

======static calender -> no updates, only time changes, template does not
-> always on a weekly basis
        

 methods to modify and update calender info ( conditional )
    -> acad mods

 methods to 
 '''

# LIBRARY IMPORTS *
from datetime import datetime
import requests
from bs4 import BeautifulSoup
import re
from robobrowser import RoboBrowser
import json


'========================================================================================================================================'
url = 'https://coursemology.org/users/sign_in'
email = 'e0425978@u.nus.edu'
password = 'slpypnda'


#assisting functions
def mapper(f,lst):
    return list( map(f,lst) )

def filterer(f,lst):
    return list( filter(f,lst) )
        
def rangL(lst):
    return range(len(lst))

'========================================================================================================================================'

class caldr:
    def __init__(self,mods,*format):
        if not mods:
            self.mods = []
        else:
            self.mods = [i for i in mods]
        self.format=format
            
        
    def mod_time_tostr(self,*format):
        total = {}
        for mod in self.mods:
            mod_time_dic = mods.event_parser()
            
            total[mod]={}
            #event is a key
            for event in mod_time_dic :
                total[mod][event]={}
                
                for timing in mod_time_dic[event]:
                    final = total[mod][event][timing]
                    final =mod_time_dic[event][timing].strftime(format)
        return total


'NESTED DICTIONARIES ARE USED'
'''
1. easier to read labelled data when assess values
2. access faster
'''
              
            
            
class commitment(caldr):
    def __init__(self,name,acad,*events):
        # all time in hours
        self.recommended = 10
        self.name = name
        if acad ==True:
            self.module = True
        self.format=format
        self.events ={} #lecture,tut,assignments
        

    def event_parser(self,*format):
        str_compile= {}
        events = self.events

        if not format:
            format=self.format
        
        for event in events:
            #event is lab, tut, etc - require labels
            #details are datetime objects
            
            value = tuple(event.values())[0]
            event = tuple(event.keys())[0]

            # to differentiate events that are static use tuple/ list
            if isinstance( value,tuple):
                str_compile[event] = {'start' : value[0].strftime(format), 'end': value[1].strftime(format)} 

            #for deadlines
            if isinstance(value ,list):
                str_compile[key]= { f'deadline {det_ind+1}':value[det_ind].strftime(format) for det_ind in rangL(value) } 
        
        return str_compile
        # returns dictionary nested inside list, each dictionary is one event,
        # dictionary keys either start,end for lessons
        # deadline i for i deadlines
        # values are datime converted into the format desired
    
    def event_adder(self,event,start,end,format):
        # for time spent on assigments
        # time spent on miscellenous activities
        
        if not format:
            format=self.format
        
        start = datetime.strptime( f"{start}",  str(format) )
        end = datetime.strptime( f"{end}", str(format) )                       
        self.events[str(event)]= {'start':start,'end':end}

    def event_remover(self,event):
        del self.event[str(event)]
        
        
    def time_checker(self,*option):
        # breakdown of time
        # specify option as 'breakdown',

        
        #1. filter all modules , dic with 'start'

        # obtain time difference between start and end for all modules, time delta object returned

        # sum up all the time delta -> total hours per week, for events,excluding assignments
        # -> thus assignments required input

        total_t = []
        #dic of events with a start (implied & end)
        time_dur_dic = mapper(lambda x:'start' in x, self.events)
        

        for key in time_dur_dic:
            #to assess specific value:
            dur = time_dur_dic[key][0] - time_dur_dic[key][1]
            hr_dur = dur/3600
            total_t .append( hr_dur )

        if sum(total_hr)<10 and self.module:
            return f'You are spending too little time on {self.name}!'

        if not option:
            return sum(total_hr)
        
        if option[0] == 'breakdown':
            return total_t

                

'''================================================================================================================================='''
###Syncing feature

#def webscrape_luminus():
    #use luminus api to assess
    #create datetime objects in data structure to feed into commitment class
    


### reading ical data
#def read_ical():
    #return datetimeobjects
    #return 



'''================================================================================================================================='''

## returns assignment dict
## { assignment_name:deadline_dt}
def scrape_cosmo(url,email,password ):
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

    return dic

b = scrape_cosmo(url,email,password )

#scrape exam details
with open('data.json', 'w') as json_file:
  json.dump(b, json_file)


def scrape_cosmo_exam(url,email,password):
    browser = RoboBrowser(parser='html.parser')
    browser.open(url)
    search = browser.get_form()
    search[ 'user[email]' ] = email
    search[ 'user[password]' ] = password
    browser.submit_form(search,submit=search.submit_fields['commit'])

    # main page
    browser.follow_link(browser.find_all('a')[2])
    browser

    #browser.get_links()
    all_links = browser.find_all('a')
    announcements_key = list(filter( lambda x: 'Announcements' in x, all_links ))[0]
    announcement_ind = all_links.index(announcements_key)
    browser.follow_link(browser.find_all('a')[announcement_ind])

    # helper function 2
    def date_extract(ind):
        return list(mapper( lambda x:list(x.children)[1], browser.find_all('h2') ))

    # helper function 3
    def matcher(lst,*matches):
        if not matches:
            matches = ['exam','reminder']
        else:
            matches=matches[0]

        return filterer(lambda x:any(string.lower() in str(x).lower() for string in matches) ,lst)

    #obtaining title objects - tags
    titles =mapper( lambda x:date_extract(1) , browser.find_all('h2'))[0]

    return titles

a = scrape_cosmo_exam(url,email,password)

'''================================================================================================================================='''
