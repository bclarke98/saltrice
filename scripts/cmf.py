#!/usr/bin/env python3
import os
import argparse

SFML_DEFAULT_FLAGS = '-Wall -ansi -pedantic -std=c++11'
SFML_DEFAULT_LIBS = '-lsfml-graphics -lsfml-window -lsfml-system'

MAKEFILE_TEMPLATE = '''\
CC = %s
CFLAGS = %s
MAIN = %s
OBJECTS = %s
%s

%s
'''

TEMPLATE = """
clean:
	\\rm output $(OBJECTS)
"""

def vdk(d, k):
    """ Verifies that the key (k) is in the dict (d) """
    try:
        d[k]
        return True
    except KeyError:
        return False

def udk(d, k, v):
    """
    Updates value at d[k] if vkd(d, k) == True

    Returns True if value is updated, False if key does not exist in d
    """
    if vdk(d, k):
        if isinstance(d[k], list):
            d[k] += v
        else:
            d[k] = v
        return True
    return False

def cdk(d, k, v, vartype=list):
    """
    Creates key/value pair of type 'vartype' if vdk(d, k) == False

    Returns True if key/value pair already existed, False if key/value pair was created
    """
    if vdk(d, k):
        return True
    else:
        if vartype is list:
            d[k] = [v]
        else:
            d[k] = vartype(v)
    return False

class MakeObject(object):
    def __init__(self, ext=''):
        self.variations = {
            '.c'   : False,
            '.cpp' : False,
            '.h'   : False,
            '.hpp' : False
        }
        udk(self.variations, ext, True)

    def add_ext(self, ext):
        udk(self.variations, ext.lower(), True)

    def should_add(self):
        return (bool(self.variations['.c'] or self.variations['.cpp']) and bool(self.variations['.h'] or self.variations['.hpp']))

    def get_ext(self):
        return '.c' if self.variations['.c'] else '.cpp'

    def __str__(self):
        return '\t[.c -> %s]\n\t[.cpp -> %s]\n\t[.h -> %s]\n\t[.hpp -> %s]' % (self.variations['.c'], self.variations['.cpp'], self.variations['.h'], self.variations['.hpp'])

class MakeRecipe(object):
    """
    Class to construct Makefile recipes, formatted as follows:

    [name]: [depend]
    	[cmd]

    """
    def __init__(self, name, depend, cmd):
        self.name, self.depend, self.cmd = name, depend, cmd

    @staticmethod
    def new_compile_recipe(name, depend):
        return MakeRecipe(name, depend, '$(CC) $(CFLAGS) -c %s -o %s' % (depend, name))


    def __str__(self):
        return '%s: %s\n\t%s' % (self.name, self.depend, self.cmd)



class MakefileBuilder(object):
    """Class to construct a Makefile suited to compile the c(pp) file(s) in a given directory"""

    def __init__(self, compiler=None, cflags=None, main_file=None, objects=None, libs=None, exe_name=None):
        """
        Constructor for MakefileBuilder class

        Parameters
        ----------
        compiler  (string) : specify compiler to use (gcc, g++, etc.)
        cflags    (list)   : specify flags to pass to compiler
        main_file (string) : specify name of the file containing "int/void main(...)"
        objects   (list)   : specify files to be omitted from being compiled and linked
        libs      (list)   : specify libraries to link
        exe_name  (string) : specify filename of compiled binary
        """
        self.data = {
            'CC': 'g++',
            'CFLAGS': ['-Wall'],
            'MAIN': 'main.o',
            'OBJECTS': ['$(MAIN)'],
            'LIBS': [],
            'EXE': os.getcwd().split('/')[-1]
        }

        self.omit = []

        if isinstance(compiler, str):
            self.data['CC'] = compiler
        if isinstance(cflags, list):
            self.data['CFLAGS'] = cflags
        if isinstance(cflags, str):
            self.data['CFLAGS'] = [i.strip() for i in cflags.split(' ') if i.strip()[0] == '-']
        if isinstance(main_file, str):
            if not main_file.endswith('.o'):
                main_file = main_file.split('.')[0] + '.o'
            self.data['MAIN'] = main_file
        if isinstance(objects, list):
            self.omit += objects
        if isinstance(objects, str):
            self.omit += [i.strip() for i in objects.split(' ') if '.' in i]
        if isinstance(libs, list):
            self.data['LIBS'] = libs
        if isinstance(libs, str):
            self.data['LIBS'] += [i.strip() for i in libs.split(' ') if i.strip()[0] == '-']
        if exe_name is not None:
            self.data['EXE'] = exe_name

    def seek_objects(self):
        objs = {}
        for i in os.listdir():
            a = i.split('.')
            fn, ext = a[0], '.' + '.'.join(a[1:])
            flag = True
            for j in ['.c', '.cpp', '.h', '.hpp']:
                if ext.endswith(j):
                    break
            else:
                flag = False
            if flag:
                if cdk(objs, fn, ext, MakeObject):
                    objs[fn].add_ext(ext)
        robjs = []
        for i in objs:
            if i in self.omit:
                continue
            elif i in self.data['MAIN']:
                robjs = ['%s%s' % (i, objs[i].get_ext())] + robjs
            elif objs[i].should_add():
                robjs.append('%s%s' % (i, objs[i].get_ext()))
        return robjs

    def generate_makefile(self):
        CC = self.data['CC']
        CFLAGS = ' '.join(self.data['CFLAGS'])
        MAIN = self.data['MAIN']
        OBJECTS = ' '.join(self.data['OBJECTS'])
        LIBS = ('LIBS = ' + ' '.join(self.data['LIBS'])) if len(self.data['LIBS']) > 0 else ''

        output_recipe = 'all : %s\n\n' % self.data['EXE'] + 'run: %s\n\t./%s ${ARGS}\n\n' % (self.data['EXE'], self.data['EXE'])
        output_recipe += str(MakeRecipe(self.data['EXE'], '$(OBJECTS)', '$(CC) $(CFLAGS) -o %s $(OBJECTS) ' % (self.data['EXE']) + ('$(LIBS)' if len(self.data['LIBS']) > 0 else '')))

        recipes = ''

        dir_objects = self.seek_objects()

        for i in self.seek_objects():
            fn, ext = i.split('.')
            if fn not in MAIN:
                OBJECTS += ' ' + fn + '.o'
            tr = str(MakeRecipe.new_compile_recipe(fn + '.o', i)) + '\n\n'
            recipes += tr

        recipes += str(MakeRecipe('clean', '', '-@rm %s $(OBJECTS) 2>/dev/null || true' % self.data['EXE'])) + '\n\n'
        recipes += str(MakeRecipe('oclean', '', '-@rm $(OBJECTS) 2>/dev/null || true'))

        mf = (MAKEFILE_TEMPLATE % (CC, CFLAGS, MAIN, OBJECTS, LIBS, output_recipe)) + '\n' + recipes
        return mf + '\n'

    def _write_makefile(self):
        try:
            with open('Makefile', 'w') as f:
                f.write(self.generate_makefile())
            print('Successfully wrote Makefile!')
        except:
            print('Failed to create Makefile.')

    def save_makefile(self):
        if 'Makefile' in os.listdir():
            print('A Makefile already exists in this directory.')
            yn = input('Would you like to override it? [y/n] ')
            if 'y' in yn.lower():
                self._write_makefile()
            else:
                print('Exiting...')
        else:
            self._write_makefile()

    @staticmethod
    def use_sfml_template(main_file=None, objects=None, additional_libs=None, exe_name=None):
        return MakefileBuilder('g++', SFML_DEFAULT_FLAGS, main_file, objects, SFML_DEFAULT_LIBS.split(' ') + ([] if not additional_libs else additional_libs), exe_name)


def main():
    print('[EasyMake-Py]\nTo list options, run this script with "-h" or "--help"\n')
    parser = argparse.ArgumentParser(description='[EasyMake-Py] A Dynamic Makefile Generator', conflict_handler='resolve')
    parser.add_argument('-c', dest='compiler', help='specify compiler to use (gcc/g++/etc)')
    parser.add_argument('-f', dest='cflags', help='specify flags for gcc/g++')
    parser.add_argument('-l', dest='libs', help='link external libraries separated by spaces')
    parser.add_argument('-m', dest='main_file', help='path to main file for project')
    parser.add_argument('-o', dest='omitted_objs', help='specify files to omit from being linked to the executable')
    parser.add_argument('-n', dest='exe', help='specify outputted executable name')
    parser.add_argument('--sfml', dest='sfml_preset', action='store_true', help='automatically include sfml libraries')
    args = parser.parse_args()

    # def __init__(self, compiler=None, cflags=None, main_file=None, objects=None, libs=None):

    if args.sfml_preset:
        mfb = MakefileBuilder.use_sfml_template(main_file = args.main_file, objects=args.omitted_objs, additional_libs = args.libs, exe_name=(None if not args.exe else args.exe))
        mfb.save_makefile()
    else:
        mfb_kwargs = {
            'compiler':args.compiler,
            'cflags':args.cflags,
            'main_file':args.main_file,
            'objects':args.omitted_objs,
            'libs':args.libs,
            'exe_name':args.exe
        }

        mfb = MakefileBuilder(**mfb_kwargs)
        mfb.save_makefile()


def old_main():
    try:
        with open('Makefile', 'w') as f:
            f.write(TEMPLATE.strip())
            print('Created Makefile in current directory.')
    except:
        print('Failed to create Makefile...')


if __name__ == '__main__':
    main()

