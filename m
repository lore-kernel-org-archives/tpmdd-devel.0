From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3 3/7] tpm: Validate the eventlog access
 before tpm_bios_log_setup
Date: Fri, 9 Sep 2016 11:28:58 -0600
Message-ID: <20160909172858.GB31769@obsidianresearch.com>
References: <1472532619-22170-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1472532619-22170-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20160830175213.GC6373@obsidianresearch.com>
	<57D2F049.4040707@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57D2F049.4040707-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
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

On Fri, Sep 09, 2016 at 10:54:25PM +0530, Nayna wrote:
> 
> 
> On 08/30/2016 11:22 PM, Jason Gunthorpe wrote:
> >On Tue, Aug 30, 2016 at 12:50:15AM -0400, Nayna Jain wrote:
> >>@@ -382,6 +370,8 @@ int tpm_chip_register(struct tpm_chip *chip)
> >>  		return rc;
> >>  	}
> >>
> >>+	tpm_bios_log_setup(chip);
> >
> >Surely this can fail, right? At least if the security fs setup fails
> >this should propogate that error.
> 
> What action we want to take if it fails to do bios_log_setup ?
> I have done all other fixes, just am not sure that if we propogate this
> error, then will it mean that tpm_chip_register (where this function is
> called) should fail ? or it is just an error logging on failure of
> bios_log_setup.

Typically we'd want to fail probe, so keep flowing it up.

I'm expecting this should only happen in fatal cases like security_fs
functions failing.

Failures like no optional ACPI/DT description should not log or return
an error up to probe..

Jason

------------------------------------------------------------------------------
