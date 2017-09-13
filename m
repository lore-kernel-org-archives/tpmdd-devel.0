From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Future of TPMDD @ Linux Security Summit / Plumbers
Date: Wed, 13 Sep 2017 16:21:25 -0700
Message-ID: <20170913232125.7e2cmsycxhb376z7@linux.intel.com>
References: <1503699356.4203.159.camel@linux.vnet.ibm.com>
 <20170825222209.GA22199@obsidianresearch.com>
 <1503703596.8359.6.camel@linux.vnet.ibm.com>
 <20170826074135.mx3i3bo6b3lrevdu@linux.intel.com>
 <20170826074843.isaxpmrotyk46u6j@linux.intel.com>
 <1503847647.5847.51.camel@linux.vnet.ibm.com>
 <alpine.LRH.2.20.1708281126230.3474@namei.org>
 <20170829121137.ovgkrcihgy5jcufu@linux.intel.com>
 <alpine.LRH.2.20.1708300003510.19193@namei.org>
 <trinity-ab47fab5-3247-446f-add3-baebe7c51350-1505335723429@3c-app-gmx-bs26>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <trinity-ab47fab5-3247-446f-add3-baebe7c51350-1505335723429@3c-app-gmx-bs26>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, George Wilson <gcwilson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 13, 2017 at 10:48:43PM +0200, Peter Huewe wrote:
> Hi Jarkko, Mimi, James, Jason, and everybody else,
> =A0
> it would be great if we could find a slot to discuss in person how we
> proceed with the mailing lists, patch flows and review cycles.
> I know there were some discussions, but atleast for my part I did not
> get the final conclusion on how we proceed and why.

The decision was to create combined mailing list for IMA and TPM. AFAIK
you were in the loop.

There's zero change to patch flow or review cycle. It's just a combined
mailing list.

The patchflow is such that for non-trivial patch sets we CC also
linux-security-module. James will document this to kernsec.org.

> Also I would like to discuss what is the current status of the move to
> kernel.org infrastructure (or atleast away from sf), and maybe we can
> find anyone here at Plumbers to remove any blocking points.

Took about month to get this. Got email at 13:37 (yes, not joking):

http://vger.kernel.org/vger-lists.html#linux-integrity

> Maybe we could also discuss how we can improve our testing strategy
> and discuss which tests currently exists.
> We have a (semi-)automatic test environment for the tpm kernel patches
> at work and we are currently exploring how to expand this further and
> automate it completely. I can give you a quick rundown on this if
> interested.

Can you link this infrastructure to my tree at infradead.org?

> Thanks,
> Peter

/Jarkko

---------------------------------------------------------------------------=
---
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
