From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] tpm: fix crash in tpm_tis
Date: Mon, 11 Apr 2016 11:41:24 +0300
Message-ID: <20160411084124.GA11322@intel.com>
References: <1460033770-20586-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<65cbfbc2-d994-452d-851c-102831ea0837@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <65cbfbc2-d994-452d-851c-102831ea0837-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Apr 07, 2016 at 07:36:54AM -0700, Jason Gunthorpe wrote:
>    I will have to look closer after the conference, but this does not look
>    right.
> 
>    I vaguely recall commenting on this before. Move the shutdown into the
>    core code to fix it.

This fix that I sent is not the right way to do it.

One example scenario:

1. TIS driver gets detached, which causes tpm_tis_remove() to be called.
2. Some in-kernel subsystem uses TPM, which should not be done since the
   hardware is already unitialized.
3. The devres subsystem sets ops to NULL.

Even though the fix is wrong I feel that it might put the rwsem into
question.

I'm just thinking that maybe there could be a release callback in
tpm_class_ops that could be called by tpm_del_char_device(). There can't
be clients for the chip at that point so no synchronization mechanism
is needed.

>    Jason

/Jarkko

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial! http://pubads.g.doubleclick.net/
gampad/clk?id=1444514301&iu=/ca-pub-7940484522588532
