From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Possible issue with tpm_crb runtime PM
Date: Tue, 20 Sep 2016 20:47:12 +0300
Message-ID: <20160920174712.GA12175@intel.com>
References: <20160920131522.GA950@intel.com>
	<5B8DA87D05A7694D9FA63FD143655C1B542EBE42@hasmsx108.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B542EBE42-Jy8z56yoSI8MvF1YICWikbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Sep 20, 2016 at 01:30:58PM +0000, Winkler, Tomas wrote:
> 
> > 
> > Hi
> > 
> > I get this (probably every time) when I do rmmod:
> > 
> > [ 4372.725616] tpm tpm0: A TPM error (325) occurred stopping the TPM
> > 
> > That is probably caused by failing TPM2_Shutdown. My guess is that runtime
> > PM patches cause this.
> > 
> > I'll verify that the problem does not occur with the next branch, which does
> > not include runtime PM patches.
> 
> Can you produce the full log?

I just compiled kernel from the 'next' branch and it doesn't have this
issue. If you want, I can recompile the kernel but that's the only error
message that is emitted and it is obviously emitted by tpm2_shutdown().
This is a Skylake m7-6Y75 machine that I use for ad-hoc testing (runs
Ubuntu 16.04 LTS, usually I test kernel with buildroot initramfs) of TPM
and SGX.

> Tomas

/Jarkko

------------------------------------------------------------------------------
