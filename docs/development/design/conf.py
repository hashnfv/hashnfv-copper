# Copyright 2015 Open Platform for NFV Project, Inc. and its contributors
#  
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#  
# http://www.apache.org/licenses/LICENSE-2.0
#  
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# What this is: Configuration file for OPNFV Copper project documentation
# generation via Sphinx.
#
# Status: Tested and used in production of Copper project documentation.
#

import datetime
import sys
import os

try:
    __import__('imp').find_module('sphinx.ext.numfig')
    extensions = ['sphinx.ext.numfig']
except ImportError:
    # 'pip install sphinx_numfig'
    extensions = ['sphinx_numfig']

# numfig:
number_figures = True
figure_caption_prefix = "Fig."

source_suffix = '.rst'
master_doc = 'index'
pygments_style = 'sphinx'
html_use_index = False
html_theme = 'sphinx_rtd_theme'

pdf_documents = [('index', u'OPNFV', u'OPNFV Copper Project', u'OPNFV')]
pdf_fit_mode = "shrink"
pdf_stylesheets = ['sphinx','kerning','a4']
#latex_domain_indices = False
#latex_use_modindex = False

latex_elements = {
    'printindex': '',
}
