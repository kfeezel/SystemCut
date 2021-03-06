# SystemCut
(Specialized) Python Script to Cut Atoms from a System

README


Scope:

	Molecular Dynamics Simulation Analysis

	These packaged python files will use a given atom id number and a distance value to analyze a part of a system using a lammps trajectory file.

	It will analyze atoms with the given id and greater with a z position greater than the distance value.  


Requirements:

	Python 3.6.2
	Cython 0.26.1
	Read/Write Permission


phantom.pyx:

	This script creates atoms at 0,0,0 when there are a variable number of atoms in each timestep.
	This allows VMD visualization of the file.

	First, it finds every unique atom in the whole file.
	Then, it cycles through the timesteps, placing the missing atoms at 0,0,0.

read_dump.pyx:

	This script reads a lammps trajectory file and reduces it to only those atoms that fit the parameters specified by the user. 
	Uses calculated, scaled, z values for distance cut off.


How To Run:

	Arguments:
		$ Variable :: Explanation
		<file name> :: name of the lammpstrj file to be analyzed
		<id of first atom> :: the atom with this id or greater will be analyzed
		<distance cut-off> :: atoms with a z value greater than this value will be analyzed  **negative numbers were not tested

	$ Explanation :: Command Syntax
	Run both commands, in order, to successfully run script.

	1. Compile phantom.pyx and read_dump.pyx to C files :: python setup.py
	2. Run Script :: python run.py <file name> <id of first atom> <distance cut-off>

Output

	This code will create two files: 
		$ Filename :: description
		"reduced_<file name>" :: Created by read_dump.pyx; The lammps trajectory file reduced to only those atoms within the parameters specified by the user.
		"padded_reduced_<file name>" :: Created by phantom.pyx; The "reduced_<file name>" file with the number of atoms per timesteps made constant.

		**Does not ouput ix, iy, iz


Extensions:

	Create a variable for the id of the last atom
	Assure use of negative numbers for the distance cut-off


Contact:

	Please send any questions, comments, concerns, or problems to: kaf128@zips.uakron.edu


Acknowledgement:

	Please recognize the author if this code is used, in whole or part, in any research with: Kevin Feezel(University of Akron)
	In addition, please recognize the author if this code is used, in whole or part, in a package or library. 
