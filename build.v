all_dirs := walk_ext('projects', '')
mut mdirs := map[string]int
for _, d in all_dirs{
  item := d.split('/')[1]
  if is_dir("projects/$item"){
    mdirs[item] = 1
  }
}

dirs := mdirs.keys()
mut names := map[string]string

tpl := read_file('projects/index.tpl.html') or { "" }

for dir in dirs{
  mut meta := read_file("projects/$dir/meta.html") or {
    println("cannot read $dir/meta.html")
    return
  }
  project_name := meta.all_before('\n')
  html:= meta.all_after('\n')
  names[dir] = project_name

  mut index_file := create('projects/$dir/index.html') or {
    print('cannot create $dir/index.html')
    return
  }
  index_file.write(tpl.replace('\$TITLE', project_name).replace('\$HTML', html))
  index_file.close()
  println('- $project_name')
}

println(dirs.len.str() + ' projects processed')


// generate projects.html

item_html := '<a title="\$NAME" href="projects/\$FOLDER" style="background-image: url(projects/\$FOLDER/thumb.jpg)"><img src="res/th.png"></a>\n'

tpl2 := read_file('projects.tpl.html') or {
  println("cannot read projects.tpl.html")
  return
}
mut projects_file := create('projects.html') or {
    print('cannot create projects.html')
    return
  }

projects_file.write(tpl2.all_before('\$PROJECT_LIST'))
mut num_projects := 0
lines := tpl2.find_between('\$PROJECT_LIST', '\$END_PROJECT_LIST').split('\n')
for line in lines {
  folder := line.trim_space()
  if folder!='' && folder in names {
    projects_file.write(item_html.replace('\$FOLDER', folder).replace('\$NAME', names[folder]))
    num_projects++
  }
}
projects_file.write(tpl2.all_after('\$END_PROJECT_LIST'))
projects_file.close()
println('\nprojects.html written with ' + num_projects.str() + ' projects.')

