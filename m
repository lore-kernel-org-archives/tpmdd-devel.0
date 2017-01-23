From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH RFC v3 5/5] tpm2: expose resource manager
 via	a device link /dev/tpms<n>
Date: Mon, 23 Jan 2017 08:14:55 -0800
Message-ID: <1485188095.2534.6.camel@HansenPartnership.com>
References: <20170119104922.vhgz4rxw6yzdrxqt@intel.com>
	<1484828380.3140.11.camel@HansenPartnership.com>
	<20170120133914.2wk43nteh2hh7n3c@intel.com>
	<20170120210522.glx4y4oui36oimld@intel.com>
	<1485107342.2504.7.camel@HansenPartnership.com>
	<1485110892.2504.12.camel@HansenPartnership.com>
	<20170122203055.zg52yraahqvn4rbv@intel.com>
	<20170122210107.zwrvuhnelrvaoe5h@intel.com>
	<20170122210441.ivzujugb3urzndhj@intel.com>
	<1485120988.2504.21.camel@HansenPartnership.com>
	<20170123140942.svnurymdxsyo6cum@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170123140942.svnurymdxsyo6cum-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-01-23 at 16:09 +0200, Jarkko Sakkinen wrote:
> On Sun, Jan 22, 2017 at 01:36:28PM -0800, James Bottomley wrote:
> > On Sun, 2017-01-22 at 23:04 +0200, Jarkko Sakkinen wrote:
> > > On Sun, Jan 22, 2017 at 11:01:07PM +0200, Jarkko Sakkinen wrote:
> > > > On Sun, Jan 22, 2017 at 10:30:55PM +0200, Jarkko Sakkinen
> > > > wrote:
> > > > > On Sun, Jan 22, 2017 at 10:48:12AM -0800, James Bottomley
> > > > > wrote:
> > > > > > On Sun, 2017-01-22 at 09:49 -0800, James Bottomley wrote:
> > > > > > > On Fri, 2017-01-20 at 23:05 +0200, Jarkko Sakkinen wrote:
> > > > > > > > 'tabrm4' branch has been now rebased. It's now on top
> > > > > > > > of
> > > > > > > > master
> > > > > > > > branch that contains Stefan's latest patch (min body
> > > > > > > > length
> > > > > > > > check) 
> > > > > > > > that I've reviewed and tested. It also contains your
> > > > > > > > updated
> > > > > > > > /dev/tpms patch.
> > > > > > > > 
> > > > > > > > I guess the 5 commits that are there now are such that
> > > > > > > > we
> > > > > > > > have 
> > > > > > > > fairly good consensus, don't we? If so, can I add your
> > > > > > > > reviewed-by 
> > > > > > > > and tested-by to my commits and vice versa?
> > > > > > > 
> > > > > > > We're still failing my test_transients.  This is the full
> > > > > > > python of 
> > > > > > > the test case:
> > > > > > > 
> > > > > > > 
> > > > > > >     def test_transients(self):
> > > > > > >         k = self.open_transients()
> > > > > > >         self.c.flush_context(k[0])
> > > > > > >         self.c.change_auth(self.c.SRK, k[1], None, pwd1)
> > > > > > >         ...
> > > > > > > 
> > > > > > > It's failing at self.c.flush_context(k[0]) with
> > > > > > > TPM_RC_VALUE.
> > > > > > >   It's 
> > > > > > > the same problem Ken complained about: TPM2_FlushContext
> > > > > > > doesn't have 
> > > > > > > a declared handle area so we don't translate the handle
> > > > > > > being
> > > > > > > sent
> > > > > > > down.  We have to fix this either by intercepting the
> > > > > > > flush
> > > > > > > and 
> > > > > > > manually translating the context, or by being dangerously
> > > > > > > clever and 
> > > > > > > marking flush as a command which takes one handle.
> > > > > > 
> > > > > > This is what the dangerously clever fix looks like.  With
> > > > > > this
> > > > > > and a
> > > > > > few other changes, my smoke tests now pass.
> > > > > > 
> > > > > > James
> > > > > 
> > > > > I don't want to be clever here. I will rather intercept the
> > > > > body
> > > > > and
> > > > > try to keep the core code simple and easy to understand.
> > > > 
> > > > It came out quite clean actually.
> > > > 
> > > > I just encapsulated handle mapping and have this in the
> > > > beginning
> > > > of
> > > > tpm2_map_command:
> > > > 
> > > > if (cc == TPM2_CC_FLUSH_CONTEXT)
> > > > 	return tpm2_map_to_phandle(space,
> > > > &cmd[TPM_HEADER_SIZE]);
> > > > 
> > > > I think this documents better what is actually going on than
> > > > tinkering
> > > > cc_attr_tbl.
> > > > 
> > > > /Jarkko
> > > 
> > > Actually what you suggested is much better idea because it will
> > > also
> > > take care of validation.
> > 
> > Yes, that's why it's clever ... I'm just always wary of clever code
> > because of the Kernighan principle.
> > 
> > >  I'm still going to keep tpm2_map_to_phandle because it makes the
> > > code flow a lot cleaner and probably sessions have to anyway make
> > > it
> > > even more complicated.
> > 
> > OK, there's one more thing that seems to be causing problems: when
> > tpm2_save_context fails because the handle no longer exists (like
> > it's
> > been flushed) it returns TPM_RC_REFERENCE_H0 not TPM_RC_HANDLE (the
> > session code does seem to return TPM_RC_HANDLE under some
> > circumstances).
> > 
> > James
> 
> What is your way for reproducing this issue? Just want to add
> a test case for my smoke test suite so that I can verify that
> the issue is fixed once I've fixed it.


It's the test_handle_clearing test in tpm2_sessions_smoke.py.  It's
probably easier if I publish the current state of my mods to your tpm2
-scripts, so here they are:

http://git.kernel.org/cgit/linux/kernel/git/jejb/tpm2-scripts.git/

James





------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
