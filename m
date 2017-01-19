From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH 1/2] tpm2: add session handle isolation to
 tpm spaces
Date: Thu, 19 Jan 2017 13:58:12 +0200
Message-ID: <20170119115812.vqaoxv77mgnuq43h@intel.com>
References: <1484752097.2717.14.camel@HansenPartnership.com>
 <1484752186.2717.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484752186.2717.16.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: tpmdd-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 18, 2017 at 10:09:46AM -0500, James Bottomley wrote:
> sessions should be isolated during each instance of a tpm space.  This
> means that spaces shouldn't be able to see each other's sessions and
> also when a space is closed, all the sessions belonging to it should
> be flushed.
> 
> This is implemented by adding a session_tbl to the space to track the
> created session handles.  Sessions can be flushed either by not
> setting the continueSession attribute in the session table or by an
> explicit flush.  In the first case we have to mark the session as
> being ready to flush and explicitly forget it if the command completes
> successfully and in the second case we have to intercept the flush
> instruction and clear the session from our table.

You could do this without these nasty corner cases by arbage collecting
when a command emits a new session handle.

When a session handle is created check if any of the spaces contain it
and remove from the array. No special cases needed.

This will render the need to do any kind of interception whatsoever
unneeded.

/Jarkko
