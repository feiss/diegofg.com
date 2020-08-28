from os import listdir
from os.path import isdir, join

# generate individual projects
dirs = [f for f in listdir('projects') if isdir(join('projects', f))]

NAMES = dict()

tpl_file = open('projects/index.tpl.html', 'r')
tpl = tpl_file.read()
tpl_file.close()

for dir in dirs:
  meta_file = open('projects/' + dir + '/meta.html', 'r')
  meta = meta_file.readlines()
  project_name = meta.pop(0).strip()
  html = ''.join(meta)
  meta_file.close()
  NAMES[dir] = project_name

  index_file = open('projects/' + dir + '/index.html', 'w')
  index_file.write(
    tpl
    .replace('$TITLE', project_name)
    .replace('$HTML', html)
  )
  index_file.close()
  print('- ' + project_name)
print(str(len(dirs))+' projects processed')


# generate project list

ITEM_HTML = '<a title="$NAME" href="projects/$FOLDER" style="background-image: url(projects/$FOLDER/thumb.jpg)"><img src="res/th.png"></a>\n'

tpl_file = open('projects.tpl.html', 'r')
tpl = tpl_file.read()
tpl_file.close()
projects_file = open('projects.html', 'w')

pos1 = tpl.index('$PROJECT_LIST')
pos2 = tpl.index('$END_PROJECT_LIST')
projects_file.write(tpl[:pos1])

num_projects = 0
lines = tpl[(pos1+len('$PROJECT_LIST')):pos2].strip().split('\n')
for line in lines:
  folder = line.strip()
  if folder and folder in NAMES:
    projects_file.write(ITEM_HTML.replace('$FOLDER', folder).replace('$NAME', NAMES[folder]))
    num_projects += 1

projects_file.write(tpl[(pos2 + len('$END_PROJECT_LIST')):])
projects_file.close()

print('\nprojects.html written with ' + str(num_projects) + ' projects.')
