from os import listdir
from os.path import isdir, join

print('')

for section in ['projects', 'archive', 'lab']:

  # generate individual projects
  dirs = [f for f in listdir(section) if isdir(join(section, f))]

  NAMES = dict()

  tpl_file = open(section+'/index.tpl.html', 'r')
  tpl = tpl_file.read()
  tpl_file.close()

  for dir in dirs:
    meta_file = open(section+'/' + dir + '/meta.html', 'r')
    meta = meta_file.readlines()
    project_name = meta.pop(0).strip()
    html = ''.join(meta)
    meta_file.close()
    NAMES[dir] = project_name

    index_file = open(section+'/' + dir + '/index.html', 'w')
    index_file.write(
      tpl
      .replace('$TITLE', project_name)
      .replace('$HTML', html)
    )
    index_file.close()
    print('- ' + project_name)
  print(str(len(dirs))+' '+section+' processed')


  # generate project list

  ITEM_HTML = '<a title="$NAME" href="'+section+'/$FOLDER" style="background-image: url('+section+'/$FOLDER/thumb.jpg)"><img src="res/th.png"></a>\n'

  tpl_file = open(section+'.tpl.html', 'r')
  tpl = tpl_file.read()
  tpl_file.close()
  projects_file = open(section+'.html', 'w')

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

  print(section+'.html written with ' + str(num_projects) + ' projects.\n')
