import virtualenv, textwrap

output = virtualenv.create_bootstrap_script(textwrap.dedent("""
import os, subprocess
def after_install(options, home_dir):
    etc = join(home_dir, 'etc')

    if not os.path.exists(etc):
        os.makedirs(etc)
    
    subprocess.call([join(home_dir, 'bin', 'pip'), 'install', 'markdown'])

    subprocess.call([join(home_dir, 'bin', 'pip'), 'install', 'WeasyPrint'])
"""))

f = open('markdown-to-pdf-bootstrap.py', 'w').write(output)