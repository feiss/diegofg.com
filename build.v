

all_dirs := walk_ext('projects', '')
mut mdirs := map[string]int
for _, d in all_dirs{
  item := d.split('/')[1]
  if is_dir("projects/$item"){
    mdirs[item] = 1
  }
}

dirs := mdirs.keys()
//NAMES := map[string]string

//tpl_file := read_file('projects/index.tpl.html')

for dir in dirs{
  mut meta := read_file('projects/$dir/meta.html')
  project_name := meta.all_before('\n')
  //meta:= meta.all_after('\n')delete(0)
  //html := meta.join()
  println(project_name)
}
/*

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
*/
