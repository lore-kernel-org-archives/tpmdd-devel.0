From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v2 1/2] tpm2: add session handle context
 saving and restoring to the space code
Date: Mon, 30 Jan 2017 23:46:43 +0200
Message-ID: <20170130214643.tvwjzc2whpczxqdt@intel.com>
References: <1485563481.3229.39.camel@HansenPartnership.com>
 <1485563558.3229.41.camel@HansenPartnership.com>
 <o6m1oe$qhp$2@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <o6m1oe$qhp$2@blaine.gmane.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Ken Goldman <kgoldman@us.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, Jan 29, 2017 at 07:35:32PM -0500, Ken Goldman wrote:
> On 1/27/2017 7:32 PM, James Bottomley wrote:
> >
> > Sessions are also isolated during each instance of a tpm space.  This
> > means that spaces shouldn't be able to see each other's sessions and
> > is enforced by ensuring that a space user may only refer to sessions
> > handles that are present in their own chip->session_tbl.  Finally when
> > a space is closed, all the sessions belonging to it should be flushed
> > so the handles may be re-used by other spaces.
> 
> This should be true for transient objects as well.

Transient objects do not need anything special. All transient objects
are flushed after command-response so you implicitly get the isolation.

/Jarkko
