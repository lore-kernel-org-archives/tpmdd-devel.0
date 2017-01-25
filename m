From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v3 5/5] tpm2: expose resource manager
 via    a device link /dev/tpms<n>
Date: Wed, 25 Jan 2017 15:42:38 +0200
Message-ID: <20170125134238.luz5uknzdcdvfljy@intel.com>
References: <1485110892.2504.12.camel@HansenPartnership.com>
 <20170122203055.zg52yraahqvn4rbv@intel.com>
 <20170122210107.zwrvuhnelrvaoe5h@intel.com>
 <20170122210441.ivzujugb3urzndhj@intel.com>
 <1485120988.2504.21.camel@HansenPartnership.com>
 <20170123140942.svnurymdxsyo6cum@intel.com>
 <20170123165823.hbgwphsqqpn6jwiz@intel.com>
 <20170123214255.vt2dumjm6jo5oxd3@intel.com>
 <1485209797.2534.29.camel@HansenPartnership.com>
 <20170125134004.g77ezmfkkhya643y@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170125134004.g77ezmfkkhya643y@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 25, 2017 at 03:40:04PM +0200, Jarkko Sakkinen wrote:
> On Mon, Jan 23, 2017 at 02:16:37PM -0800, James Bottomley wrote:
> > On Mon, 2017-01-23 at 23:42 +0200, Jarkko Sakkinen wrote:
> > > On Mon, Jan 23, 2017 at 06:58:23PM +0200, Jarkko Sakkinen wrote:
> > > > On Mon, Jan 23, 2017 at 04:09:42PM +0200, Jarkko Sakkinen wrote:
> > > > > On Sun, Jan 22, 2017 at 01:36:28PM -0800, James Bottomley wrote:
> > > > > > On Sun, 2017-01-22 at 23:04 +0200, Jarkko Sakkinen wrote:
> > > > > > > On Sun, Jan 22, 2017 at 11:01:07PM +0200, Jarkko Sakkinen
> > > > > > > wrote:
> > > > > > > > On Sun, Jan 22, 2017 at 10:30:55PM +0200, Jarkko Sakkinen
> > > > > > > > wrote:
> > > > > > > > > On Sun, Jan 22, 2017 at 10:48:12AM -0800, James Bottomley
> > > > > > > > > wrote:
> > > > > > > > > > On Sun, 2017-01-22 at 09:49 -0800, James Bottomley
> > > > > > > > > > wrote:
> > > > > > > > > > > On Fri, 2017-01-20 at 23:05 +0200, Jarkko Sakkinen
> > > > > > > > > > > wrote:
> > > > > > > > > > > > 'tabrm4' branch has been now rebased. It's now on
> > > > > > > > > > > > top of
> > > > > > > > > > > > master
> > > > > > > > > > > > branch that contains Stefan's latest patch (min
> > > > > > > > > > > > body length
> > > > > > > > > > > > check) 
> > > > > > > > > > > > that I've reviewed and tested. It also contains
> > > > > > > > > > > > your
> > > > > > > > > > > > updated
> > > > > > > > > > > > /dev/tpms patch.
> > > > > > > > > > > > 
> > > > > > > > > > > > I guess the 5 commits that are there now are such
> > > > > > > > > > > > that we
> > > > > > > > > > > > have 
> > > > > > > > > > > > fairly good consensus, don't we? If so, can I add
> > > > > > > > > > > > your
> > > > > > > > > > > > reviewed-by 
> > > > > > > > > > > > and tested-by to my commits and vice versa?
> > > > > > > > > > > 
> > > > > > > > > > > We're still failing my test_transients.  This is the
> > > > > > > > > > > full
> > > > > > > > > > > python of 
> > > > > > > > > > > the test case:
> > > > > > > > > > > 
> > > > > > > > > > > 
> > > > > > > > > > >     def test_transients(self):
> > > > > > > > > > >         k = self.open_transients()
> > > > > > > > > > >         self.c.flush_context(k[0])
> > > > > > > > > > >         self.c.change_auth(self.c.SRK, k[1], None,
> > > > > > > > > > > pwd1)
> > > > > > > > > > >         ...
> > > > > > > > > > > 
> > > > > > > > > > > It's failing at self.c.flush_context(k[0]) with
> > > > > > > > > > > TPM_RC_VALUE.
> > > > > > > > > > >   It's 
> > > > > > > > > > > the same problem Ken complained about:
> > > > > > > > > > > TPM2_FlushContext
> > > > > > > > > > > doesn't have 
> > > > > > > > > > > a declared handle area so we don't translate the
> > > > > > > > > > > handle being
> > > > > > > > > > > sent
> > > > > > > > > > > down.  We have to fix this either by intercepting the
> > > > > > > > > > > flush
> > > > > > > > > > > and 
> > > > > > > > > > > manually translating the context, or by being
> > > > > > > > > > > dangerously
> > > > > > > > > > > clever and 
> > > > > > > > > > > marking flush as a command which takes one handle.
> > > > > > > > > > 
> > > > > > > > > > This is what the dangerously clever fix looks like. 
> > > > > > > > > >  With this
> > > > > > > > > > and a
> > > > > > > > > > few other changes, my smoke tests now pass.
> > > > > > > > > > 
> > > > > > > > > > James
> > > > > > > > > 
> > > > > > > > > I don't want to be clever here. I will rather intercept
> > > > > > > > > the body
> > > > > > > > > and
> > > > > > > > > try to keep the core code simple and easy to understand.
> > > > > > > > 
> > > > > > > > It came out quite clean actually.
> > > > > > > > 
> > > > > > > > I just encapsulated handle mapping and have this in the
> > > > > > > > beginning
> > > > > > > > of
> > > > > > > > tpm2_map_command:
> > > > > > > > 
> > > > > > > > if (cc == TPM2_CC_FLUSH_CONTEXT)
> > > > > > > > 	return tpm2_map_to_phandle(space,
> > > > > > > > &cmd[TPM_HEADER_SIZE]);
> > > > > > > > 
> > > > > > > > I think this documents better what is actually going on
> > > > > > > > than
> > > > > > > > tinkering
> > > > > > > > cc_attr_tbl.
> > > > > > > > 
> > > > > > > > /Jarkko
> > > > > > > 
> > > > > > > Actually what you suggested is much better idea because it
> > > > > > > will also
> > > > > > > take care of validation.
> > > > > > 
> > > > > > Yes, that's why it's clever ... I'm just always wary of clever
> > > > > > code
> > > > > > because of the Kernighan principle.
> > > > > > 
> > > > > > >  I'm still going to keep tpm2_map_to_phandle because it makes
> > > > > > > the 
> > > > > > > code flow a lot cleaner and probably sessions have to anyway
> > > > > > > make it
> > > > > > > even more complicated.
> > > > > > 
> > > > > > OK, there's one more thing that seems to be causing problems:
> > > > > > when
> > > > > > tpm2_save_context fails because the handle no longer exists
> > > > > > (like it's
> > > > > > been flushed) it returns TPM_RC_REFERENCE_H0 not TPM_RC_HANDLE
> > > > > > (the
> > > > > > session code does seem to return TPM_RC_HANDLE under some
> > > > > > circumstances).
> > > > > > 
> > > > > > James
> > > > > 
> > > > > What is your way for reproducing this issue? Just want to add
> > > > > a test case for my smoke test suite so that I can verify that
> > > > > the issue is fixed once I've fixed it.
> > > > 
> > > > Right. Too easy. Sorry about this. I'll push a fix for this to
> > > > tabrm4 branch.
> > > 
> > > 1. I pushed a fix to the repository.
> > 
> > I don't think the fix is right; this is what you now have
> > 
> > 	} else if ((rc & TPM2_RC_REFERENCE_H0) == TPM2_RC_REFERENCE_H0)
> > {
> > 
> > That should be
> > 
> > } else if (rc == TPM2_RC_REFERENCE_H0)
> 
> Right I see your point.
> 
> And yes, also for RC_HANDLE the error handling was done incorrectly.  It
> should be masked like you said with 0xff to catch error number and the F
> flag (bit 7).
> 
> As it is format zero error code it should be fine to check without any
> mask.
> 
> Thanks for noting this. It is easy to shoot yourself into foot when
> there's lot of stuff packed :-)
> 
> /Jarkko

I think I actually add a helper to tpm.h to get the error number.

/Jarkko
