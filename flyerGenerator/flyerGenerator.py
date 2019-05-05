import jinja2, locale, tempfile, shutil, os, sys, re
from subprocess import Popen
from icalevents.icalevents import events
from datetime import date
locale.setlocale(locale.LC_ALL, '')

# netz39 events feed
url = 'http://www.netz39.de/feed/eo-events/'
# show events for the next x months
monthRange = 2
# start end dates for filtering
start = date.today().replace(day=1)
end = start.replace(year=start.year+int((start.month+monthRange-1)/12),month=(((start.month-1)+monthRange)%12)+1) #date fuu
entries = []

subtitle = start.strftime("%B") + "|" + end.strftime("%B") + " " + start.strftime("%Y")

if start.year != end.year:
  subtitle+="|"+end.strftime("%y")



class entry:
  def __init__(self,title,description):
    self.title=title.lstrip()
    self.description=description.lstrip()
    self.dates=[] # recurring events are represented event with multiple dates

def contains(list, filter):
    for x in list:
        if filter(x):
            return True
    return False

# read from url and store as entires
es = events(url,None,None,start,end)
for event in es:
  if not contains(entries, lambda x: x.title == event.summary.lstrip()):
    etr = entry(event.summary,event.description)
    etr.dates.append(event.start.strftime("%d. %B %Y (%H:%M Uhr)"))
    entries.append(etr)
  else:
    next(entry for entry in entries if entry.title==event.summary.lstrip()).dates.append(event.start.strftime("%d. %B %Y (%H:%M Uhr)"))

latex_jinja_env = jinja2.Environment(
	block_start_string = '\BLOCK{',
	block_end_string = '}',
	variable_start_string = '\VAR{',
	variable_end_string = '}',
	comment_start_string = '\#{',
	comment_end_string = '}',
	line_statement_prefix = '%%',
	line_comment_prefix = '%#',
	trim_blocks = True,
	autoescape = False,
	loader = jinja2.FileSystemLoader(os.path.abspath('.'))
)

template = latex_jinja_env.get_template('jinja2_template.tex')

def compile_tex():
    tmp_dir = tempfile.mkdtemp()
    for doctype in ['flyer','poster']:
        filename = doctype + '_' + re.sub('[^0-9a-zA-Z]+', '_', subtitle)
        in_tmp_path = os.path.join(tmp_dir, filename+'.tex')
        out_tmp_path = os.path.join(tmp_dir, filename+'.pdf')
        out_pdf_path = os.path.join(os.getcwd(), filename+'.pdf')
        rendered_tex = template.render(docclass=doctype,subtitle=subtitle,entries=entries)
        with open(in_tmp_path, 'w', encoding='utf8') as outfile:
            outfile.write(rendered_tex)
        print(in_tmp_path)
        print(tmp_dir)
        p = Popen(['xelatex', in_tmp_path, '-job-name', filename, '-output/-directory', tmp_dir])
        p.communicate()
        #shutil.copy(out_tmp_path, out_pdf_path)
    #shutil.rmtree(tmp_dir)

compile_tex()

# compile with both template options
#for doctype in ['flyer','poster']:
#  filename = doctype + '_' + re.sub('[^0-9a-zA-Z]+', '_', subtitle)
#  rendered_tex = template.render(docclass=doctype,subtitle=subtitle,entries=entries)
  #print(rendered_tex)
#  out_path = os.path.join(os.getcwd(), filename+'.pdf')
#  compile_tex(rendered_tex, out_path, filename)
