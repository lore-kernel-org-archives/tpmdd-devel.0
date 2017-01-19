From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH 2/2] tpm2: context save and restore space
 managed sessions
Date: Thu, 19 Jan 2017 07:13:12 -0500
Message-ID: <1484827992.3140.9.camel@HansenPartnership.com>
References: <1484752097.2717.14.camel@HansenPartnership.com>
         <1484752242.2717.17.camel@HansenPartnership.com>
         <20170119120400.ntvkkukm6oektvnj@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170119120400.ntvkkukm6oektvnj@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, 2017-01-19 at 14:04 +0200, Jarkko Sakkinen wrote:
> On Wed, Jan 18, 2017 at 10:10:42AM -0500, James Bottomley wrote:
> > Now that sessions are isolated, we can introduce a session_buf in 
> > the tpm2 space to save and restore them.  This allows us to have 
> > many more sessions active simultaneously (up to 
> > TPM_PT_MAX_SESSIONS).  As part of this, we must intercept and 
> > manually remove contexts for flushed sessions.
> 
> Again I don't understand the interception part. Like with transient
> objects I just catch TPM_RC_HANDLE error and forget them in the save
> part.

it's for the global session tracking patch (see other email for
details)

> PS. Do you mind if I take part of the patch that encapsulates a
> single context save as of my patch that implements transient object
> swapping? It merely moves the code in there to a different location.
> Would just make the patch set cleaner. I would do this for v4 of the
> patch set.

Sure.  Rebase should be able to do this easily for me.

James
