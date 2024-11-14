#! /usr/bin/env python
# cython: language_level=3
# distutils: language=c++

""" async check_output """

from typing import Dict
from typing import List
from typing import TypeAlias

Command    :TypeAlias = List[str]
Environment:TypeAlias = Dict[str,str]

__author__:str='you.com' # NOQA
