From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: add TPM2 version of create_tpm2_key and
 libtpm2.so engine -> Hash algoritms
Date: Wed, 4 Jan 2017 11:54:34 -0700
Message-ID: <20170104185434.GA12614@obsidianresearch.com>
References: <1483224485.2518.20.camel@HansenPartnership.com>
	<1483224763.2518.24.camel@HansenPartnership.com>
	<20170103231126.GE29656@obsidianresearch.com>
	<1483485776.2464.50.camel@HansenPartnership.com>
	<20170103234053.GA32185@obsidianresearch.com>
	<1483489026.2464.76.camel@HansenPartnership.com>
	<20170104004217.GA390@obsidianresearch.com>
	<OF69E51003.6475FD35-ON8525809E.00669529-8525809E.0067575C@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OF69E51003.6475FD35-ON8525809E.00669529-8525809E.0067575C-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Kenneth Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, ibmtpm20tss-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 04, 2017 at 01:48:44PM -0500, Kenneth Goldman wrote:
>    Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote on 01/03/2017
>    07:42:17 PM:
>    > > ... but my current TPM doesn't understand
>    > > anything other than sha1 or sha256, so it wouldn't allow more state
>    of
>    > > the art algorithms like sha224, sha384 or sha512 either.
>    >
>    > Okay, yes, that is horrible :( If it is that bad it might not be worth
>    > the effort.

>    The place to ask for new algorithms is the TCG's Device Driver
>    WG.  It's an odd WG name, but this is the WG where the TPM
>    mandatory algorithms are specified.  A real, commercial use case
>    will likely be an effective argument, since these are resource
>    constrained and cost sensitive.  SHA-384 and SHA-512 are
>    currently optional, which traditionally means they won't be
>    implemented.

We don't need the algorithm in the TPM. We just need to be able to RSA
sign an arbitary OID + externally computed hash like TPM 1.2 could.

What is the recommended way to create a key with a sign-only intent
that can be used with arbitary OID + computed hash?

James is proposing using the Decrypt op to do this job.

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
