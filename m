From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v4 3/8] tpm: validate event log access
 before tpm_bios_log_setup
Date: Thu, 6 Oct 2016 14:17:22 -0600
Message-ID: <20161006201722.GC12085@obsidianresearch.com>
References: <20161001193239.GA3862@intel.com>
	<20161002212551.GB25872@obsidianresearch.com>
	<20161003122013.GA9990@intel.com> <20161003123523.GC9990@intel.com>
	<20161003163516.GB6801@obsidianresearch.com>
	<20161003202230.GA14624@intel.com>
	<20161003211129.GA26880@obsidianresearch.com>
	<20161004052651.GB10572@intel.com>
	<20161004171231.GB17149@obsidianresearch.com>
	<57F6AFF1.4000103@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57F6AFF1.4000103-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Oct 07, 2016 at 01:41:29AM +0530, Nayna wrote:
> Are we trying to say that, once the teardown() is started, no more opening
> of files are allowed, even if they are visible ?

Yes.

> But if open() has happened first, and then teardown(), in that case private
> data is already passed to seq_open().

Yes.

> That means here the behaviour will still be same as existing..

No, the crucial difference is that the 'get_device' is now safe. It
either acquires a kref or it returns ENODEV. Since we have safely done
get_device, and hold a kref, we know the log cannot become freed since you
will move the log free to the tpm_dev_release function.

tpm_dev_release is called when the chip kref count goes to 0.

> opened files continue to access the data, and teardown will not be
> waiting for opened files to be closed() ? Is this correct
> understanding of what we are trying to do ?

Right, no waiting. Instead we defer kfree(chip) until all users are
done, including open user files. This is the same approach we use in
other parts of the subsystem.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
