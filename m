From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm: vtpm_proxy: Do not access host's
	event log
Date: Thu, 17 Nov 2016 11:33:28 -0700
Message-ID: <20161117183328.GC26039@obsidianresearch.com>
References: <1479306245-14456-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20161116153731.pmmnxiai7ouuj6qf@intel.com>
	<3a38ddc6-1758-ae82-3df3-9cc55906880d@linux.vnet.ibm.com>
	<65f392b6-5141-c726-dacb-a1649ea215de@linux.vnet.ibm.com>
	<20161116200759.GA19593@obsidianresearch.com>
	<ef1f954d-fc52-0522-01f7-b0e31ea14c59@linux.vnet.ibm.com>
	<20161117181006.GA26039@obsidianresearch.com>
	<c6e84bc7-151c-e698-e269-0ef1ebf3897b@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c6e84bc7-151c-e698-e269-0ef1ebf3897b-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Nov 17, 2016 at 01:25:54PM -0500, Stefan Berger wrote:
> 
> In the case of x86, tpm_read_log_of() is a stub return -ENODEV, which in
> turn fails the whole device:

Somehow this got screwed up during the lengthy review. ENODEV is the
right return from the leaf routines but the tests in tpm_eventlog di
not get fixed:

> http://git.infradead.org/users/jjs/linux-tpmdd.git/blob/4d388433e85f8257f5a9344a7acf6f499ba2b29e:/drivers/char/tpm/tpm_eventlog.h#l87

Is wrong, should be:

if (rc != -ENODEV)
   return rc;

And the one in tpm_bios_log_setup should be

if (rc != 0 && rc != -ENODEV)
    return rc;
    
> I think the OF log reading code will also need to check for chip->dev.parent
> being NULL.

Currect! Lets get that fixed too. :(

> Further, I had the impression that the error unwinding following -ENODEV has
> an issue related to sysfs.

I don't follow this comment..

Jason

------------------------------------------------------------------------------
