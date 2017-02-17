From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] tpm: Fix expected number of response
 bytes of TPM1.2 PCR Extend
Date: Fri, 17 Feb 2017 13:48:38 -0500
Message-ID: <1487357318.15611.68.camel@linux.vnet.ibm.com>
References: <1487177783-15687-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<20170215180903.3simazptqnlhbqi6@intel.com>
	<1487335598.15611.9.camel@linux.vnet.ibm.com>
	<20170217184546.ik2vv5bleahqhkwv@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170217184546.ik2vv5bleahqhkwv-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-02-17 at 20:45 +0200, Jarkko Sakkinen wrote:
> On Fri, Feb 17, 2017 at 07:46:38AM -0500, Mimi Zohar wrote:
> > Hi James,
> > 
> > On Wed, 2017-02-15 at 20:09 +0200, Jarkko Sakkinen wrote:
> > > On Wed, Feb 15, 2017 at 11:56:23AM -0500, Stefan Berger wrote:
> > > > The TPM1.2 PCR Extend operation only returns 20 bytes in the body,
> > > > which is the size of the PCR state.
> > > > 
> > > > This fixes a problem where IMA gets errors with every PCR Extend.
> > > > 
> > > > Fixes: c659af78eb7b ("tpm: Check size of response before accessing data")
> > > > Signed-off-by: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> > > > Acked-by: Mimi Zohar <zohar-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> > > 
> > > Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > 
> > This patch needs to be included with the rest of the patches being
> > upstreamed in the next open window.   Should Jarkko or I send you a pull
> > request for it?

> I'm sending a pull request after the weekend. It will contain
> only a few small scoped fixes so wouldn't it be easiest if I
> just include this to the pack?

As long as it makes it into the James' pull request to Linus, that's
fine.

Mimi


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
