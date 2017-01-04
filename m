From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [Ibmtpm20tss-users] [tpmdd-devel] add TPM2
 version of create_tpm2_key and libtpm2.so engine -> Hash algoritms
Date: Wed, 04 Jan 2017 11:45:21 -0800
Message-ID: <1483559121.2561.67.camel@linux.vnet.ibm.com>
References: <1483224485.2518.20.camel@HansenPartnership.com>
	<1483224763.2518.24.camel@HansenPartnership.com>
	<20170103231126.GE29656@obsidianresearch.com>
	<1483485776.2464.50.camel@HansenPartnership.com>
	<20170103234053.GA32185@obsidianresearch.com>
	<1483489026.2464.76.camel@HansenPartnership.com>
	<20170104004217.GA390@obsidianresearch.com>
	<OF69E51003.6475FD35-ON8525809E.00669529-8525809E.0067575C@notes.na.collabserv.com>
	<20170104185434.GA12614@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <trousers-tech-bounces@lists.sourceforge.net>
In-Reply-To: <20170104185434.GA12614@obsidianresearch.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=trousers-tech>
List-Post: <mailto:trousers-tech@lists.sourceforge.net>
List-Help: <mailto:trousers-tech-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/trousers-tech>,
	<mailto:trousers-tech-request@lists.sourceforge.net?subject=subscribe>
Errors-To: trousers-tech-bounces@lists.sourceforge.net
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Kenneth Goldman <kgoldman@us.ibm.com>
Cc: trousers-tech@lists.sourceforge.net, tpmdd-devel@lists.sourceforge.net, ibmtpm20tss-users@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 2017-01-04 at 11:54 -0700, Jason Gunthorpe wrote:
> On Wed, Jan 04, 2017 at 01:48:44PM -0500, Kenneth Goldman wrote:
> >    Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote on
> > 01/03/2017
> >    07:42:17 PM:
> >    > > ... but my current TPM doesn't understand
> >    > > anything other than sha1 or sha256, so it wouldn't allow
> > more state
> >    of
> >    > > the art algorithms like sha224, sha384 or sha512 either.
> >    >
> >    > Okay, yes, that is horrible :( If it is that bad it might not
> > be worth
> >    > the effort.
> 
> >    The place to ask for new algorithms is the TCG's Device Driver
> >    WG.  It's an odd WG name, but this is the WG where the TPM
> >    mandatory algorithms are specified.  A real, commercial use case
> >    will likely be an effective argument, since these are resource
> >    constrained and cost sensitive.  SHA-384 and SHA-512 are
> >    currently optional, which traditionally means they won't be
> >    implemented.
> 
> We don't need the algorithm in the TPM. We just need to be able to 
> RSA sign an arbitary OID + externally computed hash like TPM 1.2
> could.
> 
> What is the recommended way to create a key with a sign-only intent
> that can be used with arbitary OID + computed hash?

There isn't one.  TPM_ALG_NULL is illegal for sign operations.  The
Part 1 Architecture Guide (version 1.16 lists all the potentially
supported OIDs in section B.6).  The idea is that the TPM is supposed
to be able to validate that you're not causing it to generate a
nefarious signature, so you pass in the hash alone along with the
algorithm and it validates the legality of the hash and then returns
back the OID prepended hash signed by the key.

> James is proposing using the Decrypt op to do this job.

I believe the TCG has decided this is the only way to sign arbitrary
data.

James


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
