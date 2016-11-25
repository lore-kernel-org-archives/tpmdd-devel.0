From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 1/3] tpm: move event log init functions
 to tpm_eventlog_init.c
Date: Fri, 25 Nov 2016 12:43:33 -0700
Message-ID: <20161125194333.GH16504@obsidianresearch.com>
References: <1479922057-8752-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1479922057-8752-2-git-send-email-nayna@linux.vnet.ibm.com>
	<20161123193830.GB13927@obsidianresearch.com>
	<20161124210105.ykmbednlmae52tla@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161124210105.ykmbednlmae52tla-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Nov 24, 2016 at 11:01:05PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 23, 2016 at 12:38:30PM -0700, Jason Gunthorpe wrote:
> > On Wed, Nov 23, 2016 at 12:27:35PM -0500, Nayna Jain wrote:
> > > The device driver code for the event log has the init functions and
> > > TPM 1.2 parsing logic both defined in same file(tpm_eventlog.c).
> > > 
> > > Since the initialization functions are common with the TPM 2.0 event
> > > log support, this patch splits tpm_eventlog.c to have only TPM 1.2
> > > event log parsing logic and moves the init functions into
> > > tpm_eventlog_init.c.
> > 
> > I think I'd rather see a tpm_eventlog1.c/tpm_eventlog2.c than this
> > _init thing..
> 
> I would rather see tpm1-eventlog.c and tpm2-eventlog.c as we already
> have tpm2-cmd.c for the sake of consistency.

+1

Jason

------------------------------------------------------------------------------
