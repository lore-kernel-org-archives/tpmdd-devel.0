From: Ken Goldman <kgoldman@us.ibm.com>
Subject: Re: [PATCH] tpm: add session handles to the save and restore of the
 tpm2 space manager
Date: Fri, 13 Jan 2017 16:23:41 -0500
Message-ID: <o5bggj$8ts$1@blaine.gmane.org>
References: <1484335453.2527.31.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1484335453.2527.31.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: linux-security-module@vger.kernel.org
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/13/2017 2:24 PM, James Bottomley wrote:
> Session handles are slightly more difficult to manage because any TPM
> only has a finite number of allowed handles, even if the session has
> been saved; so when you context save a session, you must not flush it
> because that would destroy the ability to context load it

This is correct.

Background:  A save context for a session implicitly does flush the 
session (loaded session in TCG jargon).  However, it keeps some state
(saved session in TCG jargon) to provide anti-replay protection when
the session is later context loaded.

If you explicitly flushcontext a saved session, you're actually flushing 
that state.

> +static int tpm2_map_sessions(struct tpm_chip *chip, u8 *buf, size_t len,
> +			     size_t start)
> +{

This looks like session handles are virtualized.  I believe that this 
will break the HMAC for commands (e.g. TPM2_PolicySecret) that have
a session handle in the handle area.  The session's handle is its
"Name" and is included in the cpHash (command parameter hash) data
that is HMACed.


