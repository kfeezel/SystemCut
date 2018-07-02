#read_dump.pyx

import time

cpdef main(str name, int skip, int cut):
	
	cdef list raw_, cut_file_name, dump, atom_list, ids, id_, full_list
	cdef str file_name, file_name_edit
	cdef int line_, lines_, num_atoms, timesteps, iter_, a_id, num_cut, iteration, timestep_num
	cdef float x_lower, x_upper, x_size, y_lower, y_upper, y_size, z_lower, z_upper, z_size
	
	cut_file_name = name.split('/')
	
	raw_ = cut_file_name[len(cut_file_name)-1].split('.')
	file_name = raw_[0]
	
	file_name_edit = "reduced_%s" % (str(file_name).strip("'[]")) 
	
	input_file = open(name, "r")
	
	line_ = 0
	
	dump = []
	
	with input_file as f:
		for line in input_file:
			if line_ < 10:
				dump.append([x for x in line.split()])
			elif line_ > 10:
				break
			line_ += 1

	try:
		num_atoms = int(dump[3][0].strip("'[]"))
	
		x_lower = float(dump[5][0].strip("'[],'"))
		x_upper = float(dump[5][1].strip("'[],'"))
		x_size = abs(x_lower) + abs(x_upper)
		y_lower = float(dump[6][0].strip("'[],'"))
		y_upper = float(dump[6][1].strip("'[],'"))
		y_size = abs(y_lower) + abs(y_upper)
		z_lower = float(dump[7][0].strip("'[],'"))
		z_upper = float(dump[7][1].strip("'[],'"))
		z_size = abs(z_lower) + abs(z_upper)
	
	except:
		print("ERROR: The input file is formatted differently. Please check the indexes used for system information; read_dump.pyx:33")

	lines_ = 0
	
	input_file = open(name, "r")
	
	for line in input_file:
		lines_ += 1
	
	input_file.close()
	
	timesteps = lines_/(num_atoms+8)
	
	if timesteps % 1 != 0:
		print("Number of timesteps calculation error; read_dump.pyx:56")
	
	del dump
	
	iteration = 0
	
	cout = open(file_name_edit, "w" )
	cout.close()
	
	while iteration < timesteps:
		
		timestep_num = (iteration+1)*1000
		
		atom_list = []
	
		if iteration == 0:
			first_line = 9
			last_line = first_line + num_atoms
		elif iteration > 0:
			first_line = last_line + 9
			last_line = first_line + num_atoms
			
		line_num = 1
		
		input_file = open(name, "r")
			
		for line in input_file:
			if line_num > last_line:
				break
			if line_num > first_line and line_num <= last_line:
				atom_list.append([x for x in line.split()])
			line_num += 1
		
		input_file.close()
		
		ids = []
		id_ = []
		full_list = []
		
		for atom in atom_list:
			ids.append(int(atom[0].strip("'[],'")))
		
		for atom in atom_list:
			a_id = int(atom[0].strip("'[],'"))
			if a_id >= skip and (float(atom[4].strip("'[],'"))*z_size) > cut:
				
				prev_index = ids.index(a_id-1)
				prev = atom_list[prev_index]
				
				if a_id not in id_:
					if int(atom[1].strip("'[],'")) == 4:
						id_.append(a_id)
						id_.append(a_id+1)
						id_.append(a_id+2)
					elif (int(atom[1].strip("'[],'")) == 5):
						if int(prev[1].strip("'[],'")) == 4:
							id_.append(a_id-1)
							id_.append(a_id)
							id_.append(a_id+1)
						if int(prev[1].strip("'[],'")) == 5:
							id_.append(a_id-2)
							id_.append(a_id-1)
							id_.append(a_id)	
			
		for num in id_:
			num = int(num)
			full_ = ids.index(num)
			add_ = atom_list[full_]
			if add_ not in full_list:
				full_list.append(add_)
		
		del ids
		del id_
		
		num_cut = len(full_list)
		
		cout = open(file_name_edit, "a" )
		
		if num_cut > 0 and num_cut % 3 == 0:
			cout.write("ITEM: TIMESTEP %i\nITEM: NUMBER OF ATOMS\n%i\nITEM: BOX BOUNDS pp pp ff\n%f %f\n%f %f\n%f %f\nITEM: ATOMS id type xs ys zs\n""" % (timestep_num, num_cut, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper))
		elif num_cut % 3 != 0:
			print("ERROR: Script is cutting atoms in half; read_dump.pyx:135")
		
		for s in full_list:
			for i in s:
				cout.write("%s " % (i))
			cout.write("\n")	
			
		cout.close()
	
		del full_list
			
		iteration += 1
		
	return file_name_edit, timesteps