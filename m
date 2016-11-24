From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v5 1/3] tpm: move event log init functions
 to tpm_eventlog_init.c
Date: Thu, 24 Nov 2016 09:43:31 -0700
Message-ID: <20161124164331.GA4930@obsidianresearch.com>
References: <1479922057-8752-1-git-send-email-nayna@linux.vnet.ibm.com>
	<1479922057-8752-2-git-send-email-nayna@linux.vnet.ibm.com>
	<20161123193830.GB13927@obsidianresearch.com>
	<58369E3F.40509@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58369E3F.40509-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Nov 24, 2016 at 01:31:03PM +0530, Nayna wrote:

> >>Since the initialization functions are common with the TPM 2.0 event
> >>log support, this patch splits tpm_eventlog.c to have only TPM 1.2
> >>event log parsing logic and moves the init functions into
> >>tpm_eventlog_init.c.
> >
> >I think I'd rather see a tpm_eventlog1.c/tpm_eventlog2.c than this
> >_init thing..
> 
> Do you mean tpm_eventlog1.c for TPM 1.2 and tpm_eventlog2.c for TPM 2.0
> event log specific parsing ?
> 
> And if so, then which one should have the common functions for TPM 1.2 and
> TPM 2.0?

Leave them in tpm_eventlog.c ..

Jason

------------------------------------------------------------------------------
