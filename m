From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: Resource manager tabrm5 fails sessions
Date: Tue, 31 Jan 2017 14:59:40 -0800
Message-ID: <1485903580.3199.110.camel@HansenPartnership.com>
References: <o6qtoh$9nn$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <o6qtoh$9nn$1@blaine.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 2017-01-31 at 15:57 -0500, Ken Goldman wrote:
> Should tabrm5 have the session swapping yet?  Is there a different 
> head I should be using?

Jarkko's branch doesn't currently have sessions.  If you want the
session code, it's here:

http://git.kernel.org/cgit/linux/kernel/git/jejb/tpmdd.git/ tabrm5

It's an addition to Jarkko's, so you should be able simply to pull it
in.  However, it does contain my experimental regapping code, so treat
with caution (it is passing its test suite here, so if you find a
failure, I'm interested).

> ~~~~
> 
> I have the following test:
> 
>     create a primary storage key
>     create 2 signing keys under the storage key, each with a
> different 
> password
>     load all 2 keys
>     create an hmac session
>     sign with each key
> 
> ~~~~
> 
> When I run three of these processes, it passes.  Each test has 3 
> loaded keys (all slots filled) and one session slot filled. This 
> indicates that transient object swapping is working.
> 
> When I start fourth process, it fails creating the session.  The 
> error is:
> 
> rc 00000903 TPM_RC_SESSION_MEMORY - out of memory for session
> contexts
> 
> This indicates that session swapping is not occurring.

Right, you need to add the session swapping code, either by applying
the patch or updating from my tree.

James



------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
