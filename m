From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: add session handles to the save and restore of the
 tpm2 space manager
Date: Tue, 17 Jan 2017 09:23:57 +0200
Message-ID: <20170117072357.tlnzdmwrrr2bkzbn@intel.com>
References: <1484335453.2527.31.camel@linux.vnet.ibm.com>
 <20170116100415.ieyweqjjcg5d3zzd@intel.com>
 <1484608725.2540.88.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484608725.2540.88.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 16, 2017 at 03:18:45PM -0800, James Bottomley wrote:
> On Mon, 2017-01-16 at 12:04 +0200, Jarkko Sakkinen wrote:
> > On Fri, Jan 13, 2017 at 11:24:13AM -0800, James Bottomley wrote:
> > > Session handles are slightly more difficult to manage because any
> > > TPM
> > > only has a finite number of allowed handles, even if the session
> > > has
> > > been saved; so when you context save a session, you must not flush
> > > it
> > > because that would destroy the ability to context load it (you only
> > > flush sessions when you're done with them) and the tpm won't re-use
> > > the handle.  Additionally, sessions can be flushed as part of the
> > > successful execution of a command if the continueSession attribute
> > > is
> > > clear, so we have to mark any session we find in the command (using
> > > TPM2_HT_TAG_FOR_FLUSH) so it can be cleared from the space if the
> > > command successfully executes.
> > > 
> > > Finally, a session may also be cleared by flushing it, so we have
> > > to
> > > emulate the TPM2_FlushContext command to see if a session is being
> > > flushed and manually clear it from the space.
> > > 
> > > We also fully flush all sessions on device close.
> > 
> > Some big overview comments without going deeply into details. I will
> > use more time for this once the 
> > 
> > Please do not use handle allocation code for sessions. This commit
> > makes the implementation a mess. Just use the phandle directly and
> > have array of session phandles for each space.
> > 
> > I would also almost require to have at minimum two patches: one that
> > implements purely isolation and another that implements swapping.
> > 
> > It might be for example that I want to land TPM spaces with session
> > isolation to one release and swapping to n+1 because my hunch tells
> > me that it is better to bake the swapping part for a while.
> > 
> > One more thing. Maybe commit messages should speak uniformally about
> > TPM spaces? They are a tool to implement resource manager, not a
> > resource manager.
> 
> Yes, so Ken also had a reply to this which the Mailing List seems to
> have eaten:
> 
> > This looks like session handles are virtualized.  I believe that this 
> > will break the HMAC for commands (e.g. TPM2_PolicySecret) that have
> > a session handle in the handle area.  The session's handle is its 
> > "Name" and is included in the cpHash (command parameter hash) data 
> > that is HMACed. 
> 
> Basically this means that the advice to virtualize session handles in
> the TCG RM document is wrong and we have to use physical handles. I'll
> redo the implementation for this ... and now, since we'll have nothing
> to use as an index, it probably does make sense to have sessions in a
> separate array.  I can also separate isolation from context switching
> ... although I really think this is less optimal: my TPM only allows
> three active context handles, so if we don't context switch them
> identially to transient object (which it also only allows three of) I'm
> going to run out.  I actually redid my openssl_tpm_engine patches so
> they use session handles for parameter encryption and HMAC based
> authority, so this may end up biting me soon ...
> 
> James

This might be obvious to you but saying this just in case: everytime a
session handle is created, you must traverse through struct tpm_space
instances and check if they have that physical handle and remove it so
that they don't leak.

I would probably just create a linked list of struct tpm_space
instances. Radix tree does not make much sense with the amount of
sessions you might except to have on a system simultaneously.

Anyway, this kind of lazy approach where you clean up as new stuff
gets created is probably also the most straight forward...

/Jarkko
