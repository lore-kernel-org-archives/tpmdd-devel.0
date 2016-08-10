From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 3/3] TPM2.0:Adds securityfs support for
 TPM2.0 eventlog
Date: Wed, 10 Aug 2016 14:26:54 +0300
Message-ID: <20160810112654.GD13929@intel.com>
References: <1470771295-15680-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1470771295-15680-4-git-send-email-nayna@linux.vnet.ibm.com>
	<20160810112142.GC13929@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160810112142.GC13929-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Aug 10, 2016 at 02:25:30PM +0300, Jarkko Sakkinen wrote:
> On Tue, Aug 09, 2016 at 03:34:55PM -0400, Nayna Jain wrote:
> > Adds securityfs support for TPM2.0.
> > This patch currently supports only binary_bios_measurements.
> > 
> > Changelog v2:
> >         * Single tpm_of.c for reading both tpm and vtpm device tree values.
> >         * Some of the issues are fixed in Patch 1 itself.
> >         * Comments in tpm2.h give reference to the standard from where structs
> > 	are taken.
> > 	* Now, tpm_of.c has same code applied for both tpm and vtpm, so I think
> > 	that now it is needed to have generic types rather than endian specific type.
> > 
> > There are few preexisting issues as being mentioned in feedback and are not 
> > addressed in this patch. Reason being, I don't have much expertise of ACPI side as of now, 
> > and these changes will affect acpi,tpm,vtpm, all paths, so I would like to go slow
> > and fix them as different patch later after better understanding.
> > Hope this sounds ok to have them as different patch.
> > 
> > Issues which are not addressed are as below:
> >         * tpm_eventlog.h still has #ifdef defined, for tpm_bios_log_setup()
> >         * tpm_bios_log_setup is still being called in tpm-chip register function.
> 
> I do not understand your changelog entries. Please provide a nice one or
> most two paragraph english language description and keep breakdowns and
> changelogs in the cover letter.
> 
> Commit message does not equal to a discussion forum and I do not have
> any idea what feedback you are talking about...
> 
> Not reviewing this further. This is just terrible.

Whoops, my email client did tricks for me. Please ignore the two other
responses from me.

/Jarkko

------------------------------------------------------------------------------
What NetFlow Analyzer can do for you? Monitors network bandwidth and traffic
patterns at an interface-level. Reveals which users, apps, and protocols are 
consuming the most bandwidth. Provides multi-vendor support for NetFlow, 
J-Flow, sFlow and other flows. Make informed decisions using capacity 
planning reports. http://sdm.link/zohodev2dev
