From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH RFC 1/4] tpm: migrate struct tpm_buf to
	struct tpm_chip
Date: Wed, 4 Jan 2017 14:29:58 +0200
Message-ID: <20170104122958.nlbprc6uk37xrcju@intel.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<20170102132213.22880-2-jarkko.sakkinen@linux.intel.com>
	<20170102210101.GA5544@obsidianresearch.com>
	<20170103005737.t2qrc32xzdnvqy4b@intel.com>
	<20170103191328.GB26706@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170103191328.GB26706-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 03, 2017 at 12:13:28PM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 03, 2017 at 02:57:37AM +0200, Jarkko Sakkinen wrote:
> > On Mon, Jan 02, 2017 at 02:01:01PM -0700, Jason Gunthorpe wrote:
> > > On Mon, Jan 02, 2017 at 03:22:07PM +0200, Jarkko Sakkinen wrote:
> > > > Since there is only one thread using TPM chip at a time to transmit data
> > > > we can migrate struct tpm_buf to struct tpm_chip. This makes the use of
> > > > it more fail safe as the buffer is allocated from heap when the device
> > > > is created and not for every transaction.
> > > 
> > > Eh? What? I don't think that is the case..
> > > 
> > > We don't serialize until we hit tramsit_cmd at which point the buffer
> > > is already being used and cannot be shared between threads.
> > 
> > There is a regression in the patch. All functions that use 'tr_buf'
> > should take tpm_mutex first and use TPM_TRANSMIT_UNLOCKED. There's
> > also a similar regression in TPM space patch that I have to correct.
> 
> No, you can't steal TPM_TRANSMIT_UNLOCKED and tpm_mutex for this, that
> is to allow a chain of commands to execute atomicly, so a new lock is
> needed just for the tr_buf.
> 
> > > Why would the resource manager need a single global tpm buffer? That
> > > seems like a big regression from where we have been going. I don't
> > > think this is a good idea to go down this road.
> > 
> > What? 'tr_buf' is not specifically for resource manager. This commit
> > makes creating TPM commands more fail-safe because there is no need
> > to allocate page for every transmit.
> 
> That doesn't seem all that important, honestly. There kernel does not
> fail single page allocations without a lot of duress.
> 
> > For RM decorations this is really important because I rather would have
> > them fail as rarely as possible. If this would become a scalability
> > issue then the granularity could be reconsidered.
> 
> Why? The RM design already seems to have the prepare/commit/abort
> kind of model so it can already fail. What does it matter if the
> caller can fail before getting that far?

Yeah, I just noticed it :-) That kind of formed by accident when I
experimented with various models of rolling back in an error situation.

> It seems like alot of dangerous churn to introduce a new locking model
> without a really good reason...

OK, thanks for the feedback. I understad your arguments but as this
was an RFC patch set I don't want to go more details like these but
I take your advice seriously.

I'll start preparing the first non-RFC version. I'm happy that the beef
(i.e. the stuff in tpm2-space.c) has been well accepted!

> Jason

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most 
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
