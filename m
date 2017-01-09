From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC 2/4] tpm: validate TPM 2.0 commands
Date: Tue, 10 Jan 2017 00:17:00 +0200
Message-ID: <20170109221700.q7tq362rd6r23d5b@intel.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<20170102132213.22880-3-jarkko.sakkinen@linux.intel.com>
	<OF8D508BD2.EAB22BFD-ON0025809E.0062B40C-8525809E.006356C3@notes.na.collabserv.com>
	<1483553976.2561.38.camel@linux.vnet.ibm.com>
	<OF3FD1DF4F.FB87C3F2-ON0025809E.00682E9B-8525809E.00684A8A@notes.na.collabserv.com>
	<1483556735.2561.53.camel@linux.vnet.ibm.com>
	<OFDFABBD23.E5E1F639-ON0025809E.006924C4-8525809E.006A7568@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OFDFABBD23.E5E1F639-ON0025809E.006924C4-8525809E.006A7568-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 04, 2017 at 02:22:45PM -0500, Stefan Berger wrote:
>    James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote on 01/04/2017 02:05:35 PM:
> 
>    > From: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>    > To: Stefan Berger/Watson/IBM@IBMUS
>    > Cc: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, tpmdd-
>    > devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jason Gunthorpe
>    <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>    > Date: 01/04/2017 02:05 PM
>    > Subject: Re: [tpmdd-devel] [PATCH RFC 2/4] tpm: validate TPM 2.0
>    commands
>    >
>    > On Wed, 2017-01-04 at 13:59 -0500, Stefan Berger wrote:
>    > > [   67.699811] WARNING: CPU: 12 PID: 870 at mm/page_alloc.c:3511
>    >
>    > What's the code context around this line in your source?  Or what
>    > kernel version?  If it's this
>    >
>    >    if (order >= MAX_ORDER) {
>    >       WARN_ON_ONCE(!(gfp_mask & __GFP_NOWARN));
>    >       return NULL;
>    >    }
>    >
> 
>    I am running Jarkko's tree, the tabrm branch. 4.9.0-rc5 I think. I have
>    exactly what you are showing above.
>    > Then I think you may have returned bogus data to TPM_PT_TOTAL_COMMANDS;
>    > perhaps print nr_commands.
> 
>    Ha, what is likely the cause here is that the test suite, which implements
>    only a few commands to respond to the kernel with from the vtpm proxy
>    side, isn't feeding good data to the driver and the nr_commands ends up
>    being 0... or actually bogus data / not initialized. I guess the function
>    should check for valid input.

So, what kind of validation do you suggest? Checking it whether it is
zero?

/Jarkko

------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
