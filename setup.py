from setuptools import setup, find_packages

with open("requirements.txt") as f:
	install_requires = f.read().strip().split("\n")

# get version from __version__ variable in marley_healthcare_app/__init__.py
from marley_healthcare_app import __version__ as version

setup(
	name="marley_healthcare_app",
	version=version,
	description="Healthcare management application for Marley Healthcare",
	author="Your Company",
	author_email="support@marleyhealthcare.com",
	packages=find_packages(),
	zip_safe=False,
	include_package_data=True,
	install_requires=install_requires
)
