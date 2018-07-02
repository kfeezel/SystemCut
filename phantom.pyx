#phantom.pyx

cpdef phantom(tuple in_):
	
	cpdef int timesteps, count_, iteration, i, line_num, num_atoms_f, num_atoms_in_ts, first_line, last_line, atom_line, id_e, line_id
	cpdef str file_name, toggle_, out
	cpdef list f_, atoms, ids, l, info, ts_info, ts_list, ts_ids, e, cut_file_name
	cpdef set pad
	
	f_ = []

	for x in in_:
		f_.append(x)
	
	name = f_[0].strip('"\n[] ')
	timesteps = int(f_[1])
	
	cut_file_name = name.split('/')
	
	raw_ = cut_file_name[len(cut_file_name)-1].split('.')
	file_name = str(raw_[0])
	
	out = "padded_"+file_name
	
	covut = open(out,"w")
	
	with covut as c:
		pass 
	covut.close()
	
	del f_
	
	atoms = []
	ids = []
	
	input_file = open(name,"r")
	
	count_ = 1
	
	with input_file as f:
		for line in f:
			l = line.split()
			try:
				if len(l) == 8:
					count_ += 1
					i = int(l[0])
					if i not in ids:
						ids.append(i)
						atoms.append(line.strip("'\n[] "))
			except ValueError:
				pass
	
	input_file = open(name,"r")
		
	info = []
	
	line_num = 0
	
	with input_file as f:
		for line in f:
			if line_num < 8:
				info.append([x for x in line.split()])
			else:
				break
			line_num += 1
		
	num_atoms_f = int(str(info[2]).strip("'\n[]"))
	num_atoms_in_ts = 0
	
	iteration = 0
	
	while iteration < timesteps:
		
		if iteration == 0:
			first_line = 8
			last_line = int(first_line + num_atoms_f)
		elif iteration > 0:
			first_line = last_line + 8
			input_file = open(name,"r")
			line_num = 0
			with input_file as f:
				for line in f:
					if line_num == first_line-6:
						num_atoms_in_ts = int(str(line).strip("'[]\n"))
					elif line_num == (first_line-1):
						break
					line_num += 1
			last_line = int(first_line + num_atoms_in_ts)
					
		input_file.close()		
		
		ts_list = []
		ts_ids = []
		
		line_num = 1
		
		input_file = open(name,"r")
		
		with input_file as f:
			for line in f:
				if line_num > first_line and line_num <= last_line:
					ls = line.split()
					ts_list.append(line.strip("'[]\n "))
					ts_ids.append(int(str(ls[0]).strip("'[]\n")))
				line_num += 1
			
		pad = set(ids).difference(set(ts_ids))
		
		for each in pad:
			id_e = int(each)
			line_id = int(ids.index(id_e))
			line_ = atoms[line_id].split()
			type_ = int(line_[1])
			ts_list.append("%i %i 0 0 0 0 0 0" % (id_e, type_))
		
		if len(ts_list) != len(atoms):
			print("ERROR: The script is not creating the right number of atoms.")
		
		toggle_ = "f"
		
		cout = open(out,"a")
		with cout as c:
			for x in info:
				for s in x:
					if toggle_ == "f":
						if str(s) == "ATOMS":
							toggle_ = "t"
						cout.write("%s " % (str(s).strip("'[]\n")))
					elif toggle_ == "x":
						cout.write("%s " % (str(s).strip("'[]\n")))	
					elif toggle_ == "t":
						cout.write("%s " % (len(ts_list)))
						toggle_ = "x"
				cout.write("\n")
			for a_line in ts_list:
				cout.write("%s\n" % (str(a_line).strip("'[]\n")))
		
		cout.close()
		
		pad.clear()
		ts_ids.clear()
		ts_list.clear()
		
		iteration += 1	
