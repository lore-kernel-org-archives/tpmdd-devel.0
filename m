From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Wed, 11 Jan 2017 13:27:30 -0500
Message-ID: <7a61bdf9-da82-c772-7e73-d4a4ffc25559@linux.vnet.ibm.com>
References: <kgoldman@us.ibm.com>
	<201701041612.v04GCfPK031525@wind.enjellic.com>
	<20170109231635.6wh25qoy7svcnys6@intel.com>
	<20170110200558.GA5102@obsidianresearch.com>
	<ee6c1e48-e21f-d05e-0939-473001224aba@sit.fraunhofer.de>
	<20170111180328.GB22783@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170111180328.GB22783-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Andreas Fuchs <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, greg-R92VP3DqSWVWk0Htik3J/w@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 01/11/2017 01:03 PM, Jason Gunthorpe wrote:
> On Wed, Jan 11, 2017 at 11:00:43AM +0100, Andreas Fuchs wrote:
>
>> could we please get an ioctl, that switches the "mode" of the fd entirely.
>> I'd like to see the write()/read() support still intact.
>> All my current code uses main-loop based poll on the fd and I don't want
>> to be force to start using threads...
> We currently do not support poll in the kernel for /dev/tpmX.
>
> ie we do not supply a poll method for 'struct file_operations'.
>
> Even worse, the current implementation blocks returning from write()
> until the TPM has completed its work, so it doesn't even make sense to
> combine it with poll.

Newer applications could issue an ioctl() after the open() to unblock 
the write().

     Stefan


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
