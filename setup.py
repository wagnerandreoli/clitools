#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Package setup.

Merged with https://github.com/kennethreitz/setup.py

Note: To use the 'upload' functionality of this file, you must:
$ pip install twine

To reload the entry points on the development environment, activate the virtualenv and reinstall in dev mode:

.. code-block:: bash

    cd ~/Code/python-clitoolkit
    pyenv activate tools3
    pip install -e .
    pyenv deactivate
"""
import io
import os
import sys
from shutil import rmtree

from setuptools import Command, find_packages, setup

# Package meta-data.
NAME = 'clitoolkit'
DESCRIPTION = 'Command Line Tool Kit: CLI tools and scripts to help in everyday life'
URL = 'https://github.com/andreoliwa/python-clitoolkit'
EMAIL = 'andreoliwa@gmail.com'
AUTHOR = 'Wagner Augusto Andreoli'

# The rest you shouldn't have to touch too much :)
# ------------------------------------------------
# Except, perhaps the License and Trove Classifiers!
# If you do change the License, remember to change the Trove Classifier for that!

here = os.path.abspath(os.path.dirname(__file__))

# What packages are required for this module to be executed?
prod_requirements = [
    'argcomplete',
    'click',
    'colorlog',
    'crayons',
    'requests',
    'SQLAlchemy',
    'plumbum',
    'prettyconf',
]

dev_requirements = [
    'coverage',
    'docutils',
    'nitpick',
    'pytest-cov',
    'pytest',
    'Sphinx',
    'tox',
]

# Import the README and use it as the long-description.
# Note: this will only work if 'README.rst' is present in your MANIFEST.in file!
with io.open(os.path.join(here, 'README.rst'), encoding='utf-8') as f:
    long_description = '\n' + f.read()
with io.open(os.path.join(here, 'HISTORY.rst'), encoding='utf-8') as f:
    long_description += '\n\n' + f.read().replace('.. :changelog:', '')


# Load the package's __version__.py module as a dictionary.
about = {}
with open(os.path.join(here, NAME, '__version__.py')) as f:
    exec(f.read(), about)


class PublishCommand(Command):
    """Support setup.py publish."""

    description = 'Build and publish the package.'
    user_options = []

    @staticmethod
    def status(s):
        """Print things in bold."""
        print('\033[1m{0}\033[0m'.format(s))

    def initialize_options(self):
        """Init options."""
        pass

    def finalize_options(self):
        """End options."""
        pass

    def run(self):
        """Run the command."""
        try:
            self.status('Removing previous builds…')
            rmtree(os.path.join(here, 'dist'))
        except OSError:
            pass

        self.status('Building Source and Wheel (universal) distribution…')
        os.system('{0} setup.py sdist bdist_wheel --universal'.format(sys.executable))

        self.status('Uploading the package to PyPi via Twine…')
        os.system('twine upload dist/*')

        sys.exit()


class PyTest(Command):
    """Test command."""

    user_options = []

    def initialize_options(self):
        """Init options."""
        pass

    def finalize_options(self):
        """End options."""
        pass

    def run(self):
        """Run the command."""
        import subprocess
        import sys
        errno = subprocess.call([sys.executable, 'runtests.py'])
        raise SystemExit(errno)


# Where the magic happens:
setup(
    name=NAME,
    version=about['__version__'],
    description=DESCRIPTION,
    long_description=long_description,
    author=AUTHOR,
    author_email=EMAIL,
    url=URL,
    packages=find_packages(exclude=('tests',)),
    install_requires=prod_requirements,
    include_package_data=True,
    license='BSD',
    classifiers=[
        # Trove classifiers
        # Full list: https://pypi.python.org/pypi?%3Aaction=list_classifiers
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Natural Language :: English',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
    ],
    # $ setup.py publish support.
    cmdclass={
        'publish': PublishCommand,
        'test': PyTest,
    },
    test_suite='tests',
    tests_require=dev_requirements,
    entry_points="""
        [console_scripts]
        backup-full = {module_name}.files:backup_full
        git-local-prune = {module_name}.git:prune_local_branches
        git-vacuum = {module_name}.git:vacuum
        pycharm-cli = {module_name}.files:pycharm_cli
        pytest-run = {module_name}.files:pytest_run
        vlc-monitor = {module_name}.media:vlc_monitor
    """.format(module_name=NAME),
)
