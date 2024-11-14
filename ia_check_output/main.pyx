#! /usr/bin/env python
# cython: language_level=3
# distutils: language=c++

""" async check_output """

import asyncio
from subprocess  import CalledProcessError
from typing      import Optional
from typing      import ParamSpec
from typing      import *

from structlog   import get_logger

P     :ParamSpec = ParamSpec('P')
logger           = get_logger()

class AsyncCalledProcessError(CalledProcessError):
	""" same, but async ;) """

async def acheck_output(args:P.args, universal_newlines:bool=False,**kwargs:P.kwargs)->Union[bytes,str]:
	""" https://stackoverflow.com/a/70120267/1456735 """

	p = await asyncio.create_subprocess_exec(
		*args,
		stdout=asyncio.subprocess.PIPE,
		stderr=asyncio.subprocess.PIPE,
		**kwargs,
	)
	stdout_data:bytes
	stderr_data:bytes
	stdout_data, stderr_data = await p.communicate()
	if (stderr_data):
		await logger.aerror(stderr_data)
	if (p.returncode != 0):
		raise AsyncCalledProcessError(returncode=p.returncode, cmd=args)
	if (not universal_newlines):
		return stdout_data
	return stdout_data.decode('utf-8',
                              #errors='replace',
                              errors='ignore',) # TODO get system locale or whatever

async def _main()->None:
	args  :List[str] = ['/usr/bin/env', 'bash',]
	output:str       = await acheck_output(args, universal_newlines=True,)
	print(output,)

def main()->None:
	asyncio.run(_main())

if __name__ == '__main__':
	main()

__author__:str='you.com' # NOQA
