From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] xen-tpmfront: correct return value check on
 xenbus_scanf()
Date: Thu, 7 Jul 2016 15:21:35 +0300
Message-ID: <20160707122135.GA17711@intel.com>
References: <577E291002000078000FBF18@prv-mh.provo.novell.com>
 <20160707103554.GA13244@intel.com>
 <20160707103859.GA13815@intel.com>
 <577E607902000078000FC2FA@prv-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <577E607902000078000FC2FA@prv-mh.provo.novell.com>
Sender: stable-owner@vger.kernel.org
To: Jan Beulich <JBeulich@suse.com>
Cc: david.vrabel@citrix.com, peterhuewe@gmx.de, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, xen-devel@lists.xenproject.org, jgunthorpe@obsidianresearch.com, boris.ostrovsky@oracle.com, tpmdd@selhorst.net, Juergen Gross <JGross@suse.com>, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jul 07, 2016 at 06:00:25AM -0600, Jan Beulich wrote:
> >>> On 07.07.16 at 12:38, <jarkko.sakkinen@linux.intel.com> wrote:
> > On Thu, Jul 07, 2016 at 01:35:54PM +0300, Jarkko Sakkinen wrote:
> >> On Thu, Jul 07, 2016 at 02:04:00AM -0600, Jan Beulich wrote:
> >> > Only a positive return value indicates success.
> >> > 
> >> > Signed-off-by: Jan Beulich <jbeulich@suse.com>
> >> 
> >> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > 
> > Applied. Should this be CC'd to stable or not?
> 
> Actually the Xen code maintainers dislike this kind of change
> (expressed in reply to a change elsewhere in the tree), so
> maybe you want to sync with them whether to pull it back out.
> In any event I don't think it needs Cc-ing to stable@.

OK, it's in my master branch (bleeding edge) so no harm done yet.

> Jan

/Jarkko
