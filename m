From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] tpm/tpm_crb: Access locality for non-ACPI
 and non-SMC start method
Date: Tue, 22 Aug 2017 20:25:26 -0600
Message-ID: <20170823022526.GA4844@obsidianresearch.com>
References: <1503029736-591-1-git-send-email-anjiandi@codeaurora.org>
 <20170822173956.zpqe4scdnv7plrhj@linux.intel.com>
 <d88e255c-f8c9-b6fc-64bd-8cf56153fcce@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d88e255c-f8c9-b6fc-64bd-8cf56153fcce-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jiandi An <anjiandi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Aug 22, 2017 at 04:28:54PM -0500, Jiandi An wrote:

> I'm sorry perhaps I didn't fully understand the workaround specific to Intel
> PPT.  In previous patch thread, you mentioned the following where
> a platform could report to require start method 2 (ACPI start) which is
> sm = ACPI_TPM2_START_METHOD, and actually requires start method 8, which
> is sm = ACPI_TPM2_COMMAND_BUFFER_WITH_START_METHOD.

I'm also not sure.

To be clear, my desire to see a test that triggers only for the Intel
chips with the problem, and is written in a way that matches exactly
the ACPI data from the broken chip - so things like !CRB are not what
I want to see..

In that light the example I gave was probably not well thought out,
but I also do not understand the exact conditions needed for the Intel
work around either. Hopefully Jarkko can clarify.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
