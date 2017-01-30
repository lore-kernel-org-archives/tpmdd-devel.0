From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH v2 1/2] tpm2: add session handle context
 saving and restoring to the space code
Date: Sun, 29 Jan 2017 16:55:14 -0800
Message-ID: <1485737714.2491.13.camel@HansenPartnership.com>
References: <1485563481.3229.39.camel@HansenPartnership.com>
         <1485563558.3229.41.camel@HansenPartnership.com>
         <o6m1oe$qhp$2@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <o6m1oe$qhp$2@blaine.gmane.org>
Sender: owner-linux-security-module@vger.kernel.org
To: Ken Goldman <kgoldman@us.ibm.com>, tpmdd-devel@lists.sourceforge.net
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, 2017-01-29 at 19:35 -0500, Ken Goldman wrote:
> On 1/27/2017 7:32 PM, James Bottomley wrote:
> > 
> > Sessions are also isolated during each instance of a tpm space. 
> >  This means that spaces shouldn't be able to see each other's 
> > sessions and is enforced by ensuring that a space user may only 
> > refer to sessions handles that are present in their own chip
> > ->session_tbl.  Finally when a space is closed, all the sessions 
> > belonging to it should be flushed so the handles may be re-used by
> > other spaces.
> 
> This should be true for transient objects as well.

It is ... it's just this patch only covers sessions.

James


