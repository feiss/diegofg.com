from os import listdir
from os.path import isdir, join
dirs = [f for f in listdir('projects') if isdir(join('projects', f))]

tpl_file = open('projects/index.tpl.html', 'r')
tpl = tpl_file.read()
tpl_file.close()

for dir in dirs:
  meta_file = open('projects/' + dir + '/meta.html', 'r')
  meta = meta_file.readlines()
  project_name = meta.pop(0).strip()
  html = ''.join(meta)
  meta_file.close()

  index_file = open('projects/' + dir + '/index.html', 'w')
  index_file.write(
    tpl
    .replace('$TITLE', project_name)
    .replace('$HTML', html)
  )
  index_file.close()
  print('- ' + project_name)
print(str(len(dirs))+' projects processed')
