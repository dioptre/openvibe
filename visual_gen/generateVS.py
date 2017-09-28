#!/usr/local/bin/python

import re
import sys
from os.path import join as joinpath, split as splitpath, exists as existspath, normpath, dirname, abspath, relpath, realpath
import jinja2
import argparse

def render(tpl_path, context):
	path, filename = splitpath(tpl_path)
	return jinja2.Environment(
		loader=jinja2.FileSystemLoader(path or './')
	).get_template(filename).render(context).replace(u'\ufeff', '')

def renderToFile(outfile, tpl_path, context) :
	res = render(tpl_path, context)
	with open(outfile, "w") as f:
		f.write(res)

def getContent(file, endKeyword) :
	res = []
	for line in file :
		if line == endKeyword :
			break
		res.append(line)
	return res


if __name__ == "__main__":
	#Arguments handling
	parser = argparse.ArgumentParser(description='Generate merged Visual Studio project for OpenViBE')
	parser.add_argument('-o', '--outsln', type=str, default="OpenViBE-Meta.sln", help='Output SLN file')
	parser.add_argument('-b', '--builddir', type=str, default="build", help='Build directory where Visual Studio Solutions are located')
	args = parser.parse_args()
	build_dir = abspath(args.builddir)
	dist_dir = joinpath(dirname(build_dir), 'dist')
	outfile = args.outsln
	script_dir = dirname(realpath(__file__))
	slntpl_path = joinpath(script_dir, "OpenViBE-Meta.sln-tpl")
	usertpl_path = joinpath(script_dir, "vcxproj.user-tpl")
	designerex_path = joinpath(script_dir, "designer-extras.vcxproj-tpl")
	
	context = { 'proj_list' : [], 'proj_conf_platforms' : [], 'nested_projs' : {}}
	projects = [ 
		('SDK', "10313F85-EFD9-42AB-BF90-643A406FDD99", normpath(joinpath(build_dir, "sdk", "OpenVIBE.sln"))), 
		("Designer", "EEB9310A-3238-432D-9EAD-CDFCB35054D4", normpath(joinpath(build_dir, "designer", "Designer.sln"))), 
		("Extras", "3F5EF7F3-0F10-4F2E-ACEB-3B1326E3DA48", normpath(joinpath(build_dir, "extras", "OpenVIBE.sln")))]
	build_types = ['Debug', 'Release', 'MinSizeRel', 'RelWithDebInfo']
	
	# Generate config file for designer-extras project
	ov_env = { type : (joinpath(dist_dir, "Extras".lower(), type, "bin", "openvibe-designer.exe"), 'OV_PATH_ROOT=' + joinpath(dist_dir, "Extras".lower(), type)) for type in build_types}
	renderToFile(joinpath(build_dir, "designer-extras.vcxproj"), designerex_path, {} )
	renderToFile(joinpath(build_dir, "designer-extras.vcxproj.user"), usertpl_path, { 'configurations' : ov_env} )
	
	for folderName, folderId, path_sln in projects :
		pathprefix = relpath(dirname(path_sln), normpath(dirname(abspath(outfile))))
		# Sets the correct value for OV_PATH_ROOT; It should be possible to set multiple values separated by newline
		# Unfortunately due to a bug, this is not always possible, see https://connect.microsoft.com/VisualStudio/feedback/details/727324/msvs10-c-deu-debugger-environment-variables-missing-linefeed
		# (This is about german VS 2010, but this is also happening on french VS2013)
		ov_env = { type : (None, 'OV_PATH_ROOT=' + joinpath(dist_dir, folderName.lower(), type.upper())) for type in build_types}
		if not existspath(path_sln) :
			print(path_sln, 'does not exist !')
			continue
		print('Parsing', path_sln)
		with open(path_sln, 'r') as f:
			for line in f :
				res = re.match('Project\("{([\dABCDEF-]+)}"\)\s+=\s+"([\w\-]+)",\s+"([\w\-\\\.]+)",\s+"{([\dABCDEF\-]+)}"', line)
				if res :
					slnId, projectName, projectPath, projectId = res.groups()
					content = getContent(f, "EndProject\n")
					newpath = joinpath(pathprefix, projectPath) if len(content) else projectPath 
					tab = ['Project("{%s}") = "%s", "%s", "{%s}"\n' % (slnId, projectName, newpath, projectId)] \
						+ content \
						+ ["EndProject"]
					context['proj_list'].append(''.join(tab))
					context['nested_projs'][projectId] = folderId
					# Generate .user file
					projectfile = joinpath(dirname(path_sln), projectPath)
					userfile = projectfile + ".user"
					renderToFile(userfile, usertpl_path, { 'configurations' : ov_env} )
				elif line == "Global\n" :
					for line2 in f :
						if line2 == "\tGlobalSection(ProjectConfigurationPlatforms) = postSolution\n" :
							context['proj_conf_platforms'] += getContent(f, "\tEndGlobalSection\n")
						elif line2 == "\tGlobalSection(NestedProjects) = preSolution\n" :
							res = getContent(f, "\tEndGlobalSection\n")
							for item in res :
								key, val = re.search('{([\dABCDEF-]+)}\s=\s{([\dABCDEF-]+)}', item).groups()
								context['nested_projs'][key] = val
	try :
		renderToFile(outfile, slntpl_path, context)
	except :
		print('Could not generate %s' % (outfile,))
		sys.exit(1)
	else :
		print('Project [%s] generated' % (outfile,))