From: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] tpm: remove chip_num parameter from
 in-kernel API
Date: Tue, 24 Oct 2017 11:04:44 -0700
Message-ID: <20171024180444.aewqwgglfmb46h22@dtor-ws>
References: <20171023123817.18559-1-jarkko.sakkinen@linux.intel.com>
 <cbcb78c6-fa36-32d3-891e-96544875d97c@linux.vnet.ibm.com>
 <20171023163139.GA17394@obsidianresearch.com>
 <20171024154440.3jeupmus43jcgbbz@linux.intel.com>
 <CANc+2y4TbkfPT3d_sBd0MbE7ZJ4F7Sfsfvdv9V6=63=tRpWn4A@mail.gmail.com>
 <20171024155526.GA32250@obsidianresearch.com>
 <CANc+2y6-P9MvjbL18h02SPwNMPyk4_cPFfL6LKHDXiKSHfv00A@mail.gmail.com>
 <20171024161118.GA348@obsidianresearch.com>
 <CAKdAkRT9sLux6S1qdd=j0nbXSBdnYGG_hvjny=ic0YJLVNnxzA@mail.gmail.com>
 <20171024173757.GA1806@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171024173757.GA1806-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>, "open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA" <linux-ima-user-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, David Safford <safford-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "open list:KEYS-TRUSTED" <keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dmitry Kasatkin <dmitry.kasatkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "open list:INTEGRITY MEASUREMENT ARCHITECTURE IMA" <linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-integrity-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKWGXanvQGlWp@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Oct 24, 2017 at 11:37:57AM -0600, Jason Gunthorpe wrote:
> On Tue, Oct 24, 2017 at 10:02:00AM -0700, Dmitry Torokhov wrote:
> > tpm-rng is abomination that should be kicked out as soon as possible.
> > It wrecks havoc with the power management (TPM chip drivers may go
> > into suspend state, but tpm_rng does not do any power management and
> > happily forwards requests to suspended hardware) and may be available
> > when there is no TPM at all yet (the drivers have not been probed yet,
> > or have gotten a deferral, etc).
> 
> Makes sense
> 
> > TPM core should register HWRNGs when chips are ready.
> 
> The main thing I've wanted from the TPM RNG is
> 'add_early_randomness'..

I see... However you can't add any randomness if hardware is not quite
there yet.

> 
> We can certainly provide a TPM interface to hwrng, it seems
> reasonable.
> 
> Excep that we already have a user api in /dev/tpm to access the
> tpm RNG, is the duplication a problem?

If we already have userspace API we have to maintain this, even if it is
duplicate, there is no way around it. I'd expect most of the users will
use unified random API, while some TPM-oriented users may still go via
/dev/tpm to use the same API as all other their requests.

Thanks.

-- 
Dmitry

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
